package atlasTriangle.renderer;
import atlasTriangle.parser.AtlasTriangle;
import openfl.display.BitmapData;
import atlasTriangle.shaders.GraphicsShader;
import openfl.display.Sprite;

/**
 * ...
 * @author loudo
 */
class DrawTrianglesRenderer extends Renderer
{
	#if triangle_debug
	var _debug:Sprite;
	#end
	
	public function new(canvas:Sprite, debug:Sprite = null) 
	{
		super(canvas);
		
		#if triangle_debug
		_debug = debug;
		#end
	}
	
	override public function update(deltaTime:Int):Void 
	{
		isDirty = true;//TODO remove
		
		var _wasDirty = isDirty;
		
		if (_wasDirty)
		{
			_canvas.graphics.clear();
		}
		
		super.update(deltaTime);
		
		if (_wasDirty)
		{
			_canvas.graphics.endFill();
		}
	}
	
	override function render(bitmapID:String, shader:GraphicsShader):Void 
	{
		super.render(bitmapID, shader);
		
		#if flash
		//TODO pxb for the flash shader??
		//for now alpha is not supported on flash
		_canvas.graphics.beginBitmapFill(bitmaps.get(bitmapID), null, false, true);
		#else
		shader.bitmap.input = bitmaps.get(bitmapID);
		//shader.alpha.value = _bufferAlpha;
		shader.triangle_Alpha.value = _bufferAlpha;
		_canvas.graphics.beginShaderFill(shader, null);
		#end
		_canvas.graphics.drawTriangles(_bufferCoor, _bufferIndices, _bufferUV);
		
		#if triangle_debug
		//TODO
		_debug.graphics.lineStyle(2, 0xff0000, 0.7);
		_debug.graphics.drawTriangles(_bufferCoor, _bufferIndices, _bufferUV);
		#end
		
	}
	
}