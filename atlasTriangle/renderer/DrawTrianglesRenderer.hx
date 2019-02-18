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
	
	override function advance(deltaTime:Int):Void 
	{	
		super.advance(deltaTime);
		
		if (isDirty)
		{
			_canvas.graphics.clear();
			#if triangle_debug
			_debug.graphics.clear();
			#end
		}
		
	}
	
	override public function update(deltaTime:Int):Void 
	{
		super.update(deltaTime);
		
		//TOFIX
		if (_drawCall > 0)
		{
			_canvas.graphics.endFill();
			#if triangle_debug
			_debug.graphics.endFill();
			#end
		}
	}
	
	override function render(bitmapID:String, shader:GraphicsShader, hasColor:Bool):Void 
	{
		super.render(bitmapID, shader, hasColor);
		trace(bitmapID, _bufferCoor, "\n", _bufferUV);
		//trace(_bufferCoor, "\n", _bufferIndices, "\n", _bufferUV, "\n", _bufferAlpha);
		//trace(_bufferColorMultiplier, "\n", _bufferColorOffset);
		#if flash
		//TODO pxb for the flash shader??
		//for now alpha, shader and colortransform are not supported on flash
		_canvas.graphics.beginBitmapFill(bitmaps.get(bitmapID), null, false, true);
		#else
		shader.bitmap.input = bitmaps.get(bitmapID);
		shader.triangle_Alpha.value = _bufferAlpha;
		shader.triangle_HasColorTransform.value = [hasColor];
		if (hasColor)
		{
			shader.triangle_ColorMultiplier.value = _bufferColorMultiplier;
			shader.triangle_ColorOffset.value = _bufferColorOffset;
		}
		_canvas.graphics.beginShaderFill(shader, null);
		#end
		_canvas.graphics.drawTriangles(_bufferCoor, _bufferIndices, _bufferUV);
		
		#if triangle_debug
		//TODO
		_debug.graphics.lineStyle(2, 0xff0000, 0.7);
		_debug.graphics.drawTriangles(_bufferCoor.copy(), _bufferIndices.copy(), _bufferUV.copy());
		#end
		
	}
	
}