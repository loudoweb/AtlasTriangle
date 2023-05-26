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
		
		advance(deltaTime);
		
		var _wasDirty = isDirty;
		
		if (_wasDirty)
		{
			_canvas.graphics.clear();
			#if triangle_debug
			_debug.graphics.clear();
			#end
		}
		
		prepareBuffers();
		
		if (_wasDirty)
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
		//trace(_bufferCoor, "\n", _bufferIndices, "\n", _bufferUV, "\n", _bufferAlpha);
		//trace(_bufferColorMultiplier, "\n", _bufferColorOffset);
		#if flash
		//TODO pxb for the flash shader??
		//for now alpha, shader and colortransform are not supported on flash
		_canvas.graphics.beginBitmapFill(bitmaps.get(bitmapID), null, false, true);
		#else
		shader.bitmap.input = bitmaps.get(bitmapID);
		shader.bitmap.filter = LINEAR;
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
		_debug.graphics.lineStyle(2, 0xff0000, 0.7);
		var t = 0;
		for (i in 0..._bufferIndices.length)
		{
			var buf = _bufferIndices[i];
			var x = _bufferCoor[buf * 2];
			var y = _bufferCoor[buf * 2 + 1];
			if (t == 0){
				_debug.graphics.moveTo(x, y);
			}
			_debug.graphics.lineTo(x, y);
			t++;
			if (t == 3)
			{
				buf = _bufferIndices[i - 2];
				x = _bufferCoor[buf * 2];
				y = _bufferCoor[buf * 2 + 1];
				_debug.graphics.lineTo(x, y);
				t = 0;
			}
		}
		#end
		
	}
	
}