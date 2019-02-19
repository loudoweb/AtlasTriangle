package atlasTriangle.renderer;
import atlasTriangle.SpriteTriangle;
import haxe.ds.StringMap;
import lime.utils.Log;
import openfl.Vector;
import openfl.display.BitmapData;
import atlasTriangle.shaders.GraphicsShader;
import openfl.display.Sprite;
import openfl.geom.Matrix;
#if gl_stats
import openfl._internal.renderer.context3D.stats.Context3DStats;
#end

@:access(openfl.geom.Matrix)
@:access(openfl.display.DisplayObject)

/**
 * ...
 * @author loudo
 */
class Renderer
{
	
	var _children:Array<SpriteTriangle>;
	
	var _bufferCoor:Vector<Float>;
	var _bufferUV:Vector<Float>;
	var _bufferIndices:Vector<Int>;
	var _bufferAlpha:Array<Float>;
	var _bufferColorMultiplier:Array<Float>;
	var _bufferColorOffset:Array<Float>;
	
	var _canvas:Sprite;
	
	var _lastBitmap:String;
	var _lastShader:GraphicsShader;
	
	var _drawCall:Int = 0;
	
	public var isDirty:Bool;
	public var hasColorTransform:Bool;
	
	public var bitmaps:StringMap<BitmapData>;

	public function new(canvas:Sprite) 
	{
		_canvas = canvas;
		_children = [];
		_bufferCoor = new Vector<Float>();
		_bufferUV = new Vector<Float>();
		_bufferIndices = new Vector<Int>();
		_bufferAlpha = [];
		_bufferColorMultiplier = [];
		_bufferColorOffset = [];
		bitmaps = new StringMap<BitmapData>();
		hasColorTransform = false;
	}
	
	public function update(deltaTime:Int):Void
	{
		
		advance(deltaTime);
		prepareBuffers();
		
	}
	
	inline function advance(deltaTime:Int):Void
	{
		var _current:SpriteTriangle;
		
		for (i in 0..._children.length)
		{
			_current = _children[i];
			_current.update(deltaTime);
			if (_current.isDirty)
			{
				isDirty = true;
			}
			if (_current.colorTransform != null)
			{
				hasColorTransform = true;
			}
		}
	}
	
	function prepareBuffers():Void
	{
		if (isDirty)
		{
			cleanBuffers();
			
			var _current:SpriteTriangle;
						
			_lastBitmap = "";
			_lastShader = null;
			var _render:Bool;
			
			var _len = 0;
			var _len2 = 0;
			var _len3 = 0;
			var triangleTransform = #if !flash Matrix.__pool.get () #else new Matrix() #end;//TODO pool for flash
			
			var defaultColorTransform = #if !flash _canvas.__worldColorTransform #else _canvas.transform.colorTransform #end;
			var currentColorTransform = null;

			for (i in 0..._children.length)
			{
				_render = false;
				
				_current = _children[i];
				_current.isDirty = false;
				
				triangleTransform.setTo (1, 0, 0, 1, -_current.center.x, -_current.center.y);
				triangleTransform.concat (_current.matrix);
				//triangleTransform.concat (parentTransform);
				//triangleTransform.tx = Math.round (triangleTransform.tx);
				//triangleTransform.ty = Math.round (triangleTransform.ty);
				
				if (_current.textureID != _lastBitmap) {
					if (_lastBitmap != "")
					{
						_render = true;
						
					}else {
						_lastBitmap = _current.textureID;
					}
				}
				if (_current.shader != _lastShader){
					if (_lastShader != null)
					{
						_render = true;
						
					}else {
						_lastShader = _current.shader;
					}
				}
				if (_render)
				{
					render(_lastBitmap, _lastShader, hasColorTransform);
					_len = 0;
					_len2 = 0;
					_len3 = 0;
					cleanBuffers();
					_lastBitmap = _current.textureID;
					_lastShader = _current.shader;
				}
				
				//_bufferCoor = _bufferCoor.concat(_current.coor_computed);
				//_bufferUV = _bufferUV.concat(_current.uv);
				//_bufferIndices = _bufferIndices.concat(_current.indices);
				

				for (j in 0..._current.uv.length)
				{
					_bufferUV[_len2 + j] = _current.uv[j];
				}
				_len2 += _current.uv.length;
				
				
				if (hasColorTransform)
				{
					currentColorTransform = _current.colorTransform != null ? _current.colorTransform : defaultColorTransform;
				}
				
				for (j in 0..._current.indices.length)
				{
					_bufferAlpha[_len3 + j] = _current.alpha;
					_bufferIndices[_len3 + j] = _current.indices[j] + Std.int(_len / 2);
					
					if (hasColorTransform)
					{
						_bufferColorMultiplier[(_len3 + j) * 4] = currentColorTransform.redMultiplier;
						_bufferColorMultiplier[(_len3 + j) * 4 + 1] = currentColorTransform.greenMultiplier;
						_bufferColorMultiplier[(_len3 + j) * 4 + 2] = currentColorTransform.blueMultiplier;
						_bufferColorMultiplier[(_len3 + j) * 4 + 3] = currentColorTransform.alphaMultiplier;
						_bufferColorOffset[(_len3 + j) * 4] = currentColorTransform.redOffset;
						_bufferColorOffset[(_len3 + j) * 4 + 1] = currentColorTransform.greenOffset;
						_bufferColorOffset[(_len3 + j) * 4 + 2] = currentColorTransform.blueOffset;
						_bufferColorOffset[(_len3 + j) * 4 + 3] = currentColorTransform.alphaOffset;
					}
				}

				_len3 += _current.indices.length;
				
				for (j in 0..._current.coordinates.length)
				{
					if (j % 2 == 0) {
						#if !flash
						_bufferCoor[_len + j] = triangleTransform.__transformX(_current.coordinates[j], _current.coordinates[j + 1]);
						#else
						_bufferCoor[_len + j] = _current.coordinates[j] * triangleTransform.a + _current.coordinates[j + 1] * triangleTransform.c + triangleTransform.tx;
						#end
					}else {
						#if !flash
						_bufferCoor[_len + j] = triangleTransform.__transformY(_current.coordinates[j - 1], _current.coordinates[j]);
						#else
						_bufferCoor[_len + j] = _current.coordinates[j - 1] * triangleTransform.b + _current.coordinates[j] * triangleTransform.d + triangleTransform.ty;
						#end
					}
				}
				_len += _current.coordinates.length;				

			}
			
			isDirty = false;
			hasColorTransform = false;
			
			if(_len3 > 0)
				render(_lastBitmap, _lastShader, hasColorTransform);
				
			#if !flash
			Matrix.__pool.release (triangleTransform);
			#end
			
		}
		
		
		
		#if gl_stats
		Log.info('$_drawCall drawCalls (total ${Context3DStats.totalDrawCalls()})');//must compile with -Dgl_stats
		#else
		Log.info('$_drawCall drawCalls');
		#end
		_drawCall = 0;
	}
	
	inline function cleanBuffers():Void
	{
		#if flash
		_bufferCoor.splice(0, _bufferCoor.length);
		_bufferUV.splice(0, _bufferUV.length);
		_bufferIndices.splice(0, _bufferIndices.length);
		_bufferAlpha.splice(0, _bufferAlpha.length);
		_bufferColorMultiplier.splice(0, _bufferColorMultiplier.length);
		_bufferColorOffset.splice(0, _bufferColorOffset.length);
		#else
		//don't use splice to empty the buffers, otherwise Vector sent will be overwritten before rendering
		//TODO use pool
		_bufferCoor = new Vector<Float>();
		_bufferUV = new Vector<Float>();
		_bufferIndices = new Vector<Int>();
		_bufferAlpha = [];
		_bufferColorMultiplier = [];
		_bufferColorOffset = [];
		#end
		
	}
	
	function render(bitmapID:String, shader:GraphicsShader, hasColor:Bool):Void
	{
		_drawCall++;	
	}
	
	public function addChild(sprite:SpriteTriangle):Void
	{
		_children.push(sprite);
		isDirty = true;
	}
	
	public function addChildAt(sprite:SpriteTriangle, index:Int):Void
	{
		
		if( index > _children.length){
			_children.push(sprite);
		}else if(index <= 0){
			_children.unshift(sprite);
		}else {
			_children.insert(index, sprite);
		}
		isDirty = true;
	}
	
	/**
	 * Remove a SpriteTriangle from screen
	 * @param	index of the SpriteTriangle you want to remove
	 */
	public function removeChildAt(index:Int):Void 
	{
		if (index >= 0 && index < _children.length) {
			_children.splice(index, 1);
		}else {
			trace('index outside range');
		}
		isDirty = true;
	}
	/**
	 * Remove all SpriteTriangle from screen
	 */
	public function removeAll():Void
	{
		_children.splice(0, _children.length);
		isDirty = true;
	}
	
	/**
	 * Retrieve the index of a SpriteTriangle
	 * @param	spriter
	 * @return index
	 */
	public function getIndex(sprite:SpriteTriangle):Int
	{
		return _children.indexOf(sprite);
	}
	
	/**
	 * Get a SpriteTriangle from its index
	 * @param	index
	 * @return
	 */
	public function getSpriterAt(index:Int):SpriteTriangle
	{
		if (index >= 0 && index < _children.length)
			return _children[index];
		else
			trace("index outside range");
		return null;
	}
	
	/**
	 * Swaps the indexes of two children.
	 * @param	spriter1
	 * @param	spriter2
	 */
	public function swap(sprite1:SpriteTriangle, sprite2:SpriteTriangle):Void
	{
		var index1 = getIndex(sprite1);
		var index2 = getIndex(sprite2);
		if (index1 == -1 || index2 == -1) trace("Not in this container");
		swapAt(index1, index2);
	}
	
	/**
	 * Swaps the indexes of two children.
	 * @param	index1
	 * @param	index2
	 */
	public function swapAt(index1:Int, index2:Int):Void
	{
		var spriter1 = getSpriterAt(index1);
		var spriter2 = getSpriterAt(index2);
		_children[index1] = spriter2;
		_children[index2] = spriter1;
		isDirty = true;
	}
	
}