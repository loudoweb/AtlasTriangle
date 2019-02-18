package atlasTriangle.parser;
import openfl.Vector;
import openfl.geom.Rectangle;
using StringTools;

/**
 * Atlas packed with triangles/polygons instead of squares.
 * Should reduce size of atlas and drawing surface, but takes more memory to manage more triangles.
 * @author loudo
 */
class AtlasTriangle
{

	public var meshes:Map<String, Mesh>;
	public var textureID:String;
	
	public function new() 
	{
		meshes = new Map<String, Mesh>();
	}
	
	/**
	 * Save data of a Sprite
	 * @param	name
	 * @param	indices
	 * @param	uv
	 * @param	coordinates
	 */
	public function add(name:String, indices:Vector<Int>, uv:Vector<Float>, coordinates:Vector<Float>, oW:Int = 0, oH:Int = 0, bounds:Rectangle = null)
	{
		meshes.set(name, new Mesh(indices, uv, coordinates, textureID, oW, oH, bounds));
	}
	/**
	 * Get data of a Sprite
	 * @param	name of the Sprite in the atlas
	 * @return
	 */
	public function get(name:String):Mesh
	{
		if (meshes.exists(name))
		{
			return meshes.get(name);
		}
		return null;
	}
	/**
	 * Get data of a Clip
	 * @param	name of the Sprite in the atlas
	 * @return All meshes starting with `name`
	 */
	public function getClip(name:String):Array<Mesh>
	{
		var clip = new Array<Mesh>();
		for (key in meshes.keys())
		{
			if (key.startsWith(name)) 
				clip.push(meshes.get(key));
		}
		//TODO ordering? cache?
		return clip;
	}
	
}