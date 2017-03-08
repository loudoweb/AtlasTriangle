package atlasTriangle.parser;
import atlasTriangle.parser.AtlasTriangle;
import haxe.xml.Fast;

/**
 * Tools: TexturePacker
 * Export format: XML (generic) with Algorithm: Polygon
 * Limitation: for now the atlas needs to be Power of 2.
 * @author loudo
 */
class TexturePackerParser extends AtlasTriangle
{

	public function new(xml:Xml, atlasSize:Int) 
	{
		super();
		
		var fast:Fast = new Fast(xml.firstElement());
		
		for (sprite in fast.nodes.sprite)
		{
			var indices:Array<Int> = sprite.node.triangles.innerData.toString().split(' ').map(function (str:String) return Std.parseInt(str));
			var uv:Array<Float> = sprite.node.verticesUV.innerData.toString().split(' ').map(function (str:String) return Std.parseInt(str) / atlasSize);
			var vertices:Array<Float> = sprite.node.vertices.innerData.toString().split(' ').map(function (str:String) return Std.parseFloat(str));
			add(sprite.att.n, indices, uv, vertices);
		}
		
	}
	
}