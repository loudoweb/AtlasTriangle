package atlasTriangle.parser;
import openfl.Vector;
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
	public function add(name:String, indices:Vector<Int>, uv:Vector<Float>, coordinates:Vector<Float>)
	{
		meshes.set(name, new Mesh(indices, uv, coordinates, textureID));
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
	 * @return
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