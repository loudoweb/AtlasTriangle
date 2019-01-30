package atlasTriangle.parser;
import openfl.Vector;

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
	
	public function new(indices:Vector<Int>, uv:Vector<Float>, coordinates:Vector<Float>, textureID:String ) 
	{
		this.indices = indices;
		this.uv = uv;
		this.coordinates = coordinates;
		this.textureID = textureID;
	}
	
}