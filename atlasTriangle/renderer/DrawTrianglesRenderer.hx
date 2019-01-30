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
		
		shader.bitmap.input = bitmaps.get(bitmapID);
		shader.alpha.value = _bufferAlpha;
		trace(_bufferAlpha.length, _bufferIndices.length);
		trace(_bufferAlpha);
		
		_canvas.graphics.beginShaderFill(shader, null);
		
		_canvas.graphics.drawTriangles(_bufferCoor, _bufferIndices, _bufferUV);
		
	}
	
}