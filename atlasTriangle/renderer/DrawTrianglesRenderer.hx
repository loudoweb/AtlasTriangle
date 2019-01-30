package atlasTriangle.renderer;
import atlasTriangle.parser.AtlasTriangle;
import openfl.display.BitmapData;
import openfl.display.Sprite;

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
	
	override function render(bitmapID:String):Void 
	{
		trace(bitmapID, "\n",_bufferCoor,"\n", _bufferIndices,"\n", _bufferUV);
		_canvas.graphics.beginBitmapFill(bitmaps.get(bitmapID));
		_canvas.graphics.drawTriangles(_bufferCoor, _bufferIndices, _bufferUV);
		
	}
	
}