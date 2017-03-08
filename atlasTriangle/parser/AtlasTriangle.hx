package atlasTriangle.parser;

/**
 * ...
 * @author loudo
 */
class AtlasTriangle
{

	public var mesh:Map<String, SpriteTriangle>;
	
	public function new() 
	{
		mesh = new Map<String, SpriteTriangle>();
	}
	
	/**
	 * Save data of a Sprite
	 * @param	name
	 * @param	indices
	 * @param	uv
	 * @param	coordinates
	 */
	public function add(name:String, indices:Array<Int>, uv:Array<Float>, coordinates:Array<Float>)
	{
		mesh.set(name, new SpriteTriangle(indices, uv, coordinates));
	}
	/**
	 *  Get data of a Sprite
	 * @param	name of the Sprite in the atlas
	 * @return
	 */
	public function get(name:String):SpriteTriangle
	{
		if (mesh.exists(name))
		{
			return mesh.get(name);
		}
		return null;
	}
	
}