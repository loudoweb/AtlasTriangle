package atlasTriangle.parser;
import atlasTriangle.parser.AtlasTriangle;

/**
 * Tools: SpriteUV2
 * @author loudo
 */
typedef SpriteUV = {
  var mat:Material;
  var mesh:Array<Mesh>;
}
typedef Material = {
  var name:String;
  var txName:Array<String>;
}
typedef Mesh = {
  var mat:String;
  var name:String;
  var pos:MeshPos;
  var tri:Array<Int>;
  var uv:Array<Float>;
  var v2:Array<Float>;
}
typedef MeshPos = {
	var x:Float;
	var y:Float;
	var z:Float;
}
class SpriteUVParser extends AtlasTriangle
{
	
	/**
	 * 
	 * @param	json
	 * @param	topLeft fix origin to topleft by default (SpriteUV set it to bottom left)
	 */
	public function new(json:String, topLeft:Bool = true) 
	{
		super();
		
		var data:SpriteUV = haxe.Json.parse(json);
		textureID = data.mat.txName;
		
		for (i in 0...data.mesh.length)
		{
			var mesh = data.mesh[i];
			if (topLeft)
			{
				
				for (j in 0...mesh.uv.length)
				{
					if(j % 2 != 0)
						mesh.uv[j] = 1 - mesh.uv[j];
				}
				for (j in 0...mesh.v2.length)
				{
					if(j % 2 != 0)
						mesh.v2[j] = 1 - mesh.v2[j];
				}
			}
			add(mesh.name, mesh.tri, mesh.uv, mesh.v2);
		}
		
	}
	
}