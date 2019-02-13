package atlasTriangle.parser;
import openfl.Vector;
import openfl.geom.Rectangle;

/**
 * ...
 * @author loudo
 */
class Mesh
{

	public var indices:Vector<Int>;//TODO fixed length
	public var uv:Vector<Float>;//TODO fixed length
	public var coordinates:Vector<Float>;//TODO fixed length
	public var textureID:String;
	public var oW:Int;
	public var oH:Int;
	public var bounds:Rectangle;
	
	public function new(indices:Vector<Int>, uv:Vector<Float>, coordinates:Vector<Float>, textureID:String, oW:Int = 0, oH:Int = 0, bounds:Rectangle = null ) 
	{
		this.indices = indices;
		this.uv = uv;
		this.coordinates = coordinates;
		this.textureID = textureID;
		this.oW = oW;
		this.oH = oH;
		this.bounds = bounds;
	}
	
}