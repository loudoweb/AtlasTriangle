package atlasTriangle.renderer;
import atlasTriangle.parser.AtlasTriangle;
import openfl.display.BitmapData;
import openfl.display.Shader;
import openfl.display.Sprite;
import openfl.filters.ShaderFilter;
import atlasTriangle.shaders.AlphaGraphicsShader;

/**
 * ...
 * @author loudo
 */
class DrawTrianglesRenderer extends Renderer
{

	public function new(canvas:Sprite) 
	{
		super(canvas);
	}
	
	override public function update():Void 
	{
		isDirty = true;//TODO remove
		
		var _wasDirty = isDirty;
		
		if (_wasDirty)
		{
			_canvas.graphics.clear();
		}
		
		super.update();
		
		if (_wasDirty)
		{
			_canvas.graphics.endFill();
		}
	}
	
	override function render(bitmapID:String, shader:AlphaGraphicsShader):Void 
	{
		
		
		#if flash
		//TODO pxb for the flash shader??
		//for now alpha is not supported on flash
		_canvas.graphics.beginBitmapFill(bitmaps.get(bitmapID), null, false, true);
		#else
		shader.bitmap.input = bitmaps.get(bitmapID);
		shader.alpha.value = _bufferAlpha;
		_canvas.graphics.beginShaderFill(shader, null);
		#end
		_canvas.graphics.drawTriangles(_bufferCoor, _bufferIndices, _bufferUV);
		
	}
	
}