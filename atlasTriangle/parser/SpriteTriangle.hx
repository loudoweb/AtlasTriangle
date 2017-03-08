package atlasTriangle.parser;

/**
 * ...
 * @author loudo
 */
class SpriteTriangle
{

	public var indices:Array<Int>;
	public var uv:Array<Float>;
	public var coordinates:Array<Float>;
	
	public function new(indices:Array<Int>, uv:Array<Float>, coordinates:Array<Float> ) 
	{
		this.indices = indices;
		this.uv = uv;
		this.coordinates = coordinates;
	}
	
}