package atlasTriangle.parser;
import atlasTriangle.parser.AtlasTriangle;
import openfl.Vector;
import openfl.geom.Rectangle;

#if (haxe_ver >= 4)
typedef Access = haxe.xml.Access;
#else
typedef Access = haxe.xml.Fast;
#end

typedef TexturePackerPolygon = {
  var frames:Array<Sprite>;
  var meta:Meta;
}
typedef Meta = {
	var image:String;
	var size:Size;
	var format:String;
	var scale:Float;
}
typedef Size = {
	var w:Int;
	var h:Int;
}
typedef Sprite = {
	var filename:String;
	var frame:Frame;
	var rotated:Bool;
	var trimmed:Bool;
	var spriteSourceSize:Frame;
	var sourceSize:Size;
	var pivot:Pivot;
	var vertices:Array<Array<Float>>;
	var verticesUV:Array<Array<Float>>;
	var triangles:Array<Array<Int>>;
}
typedef Frame = {
	var x:Int;
	var y:Int;
	var w:Int;
	var h:Int;
}
typedef Pivot = {
	var x:Int;
	var y:Int;
}

/**
 * Tools: TexturePacker
 * Export format: XML (generic) or JSON (generic) with Algorithm: Polygon
 * @author loudo
 */
class TexturePackerParser extends AtlasTriangle
{

	public static function parseXML(xml:Xml):TexturePackerParser
	{
		var t = new TexturePackerParser();
		var fast:Access = new Access(xml.firstElement());
		
		t.textureID = fast.att.imagePath;
		
		var w = Std.parseInt(fast.att.width);
		var h = Std.parseInt(fast.att.height);
		
		var i:Int;
		
		for (sprite in fast.nodes.sprite)
		{
			i = 0;
			
			var indices:Vector<Int> = Vector.ofArray(sprite.node.triangles.innerData.toString().split(' ').map(Std.parseInt));
			var uv:Vector<Float> = Vector.ofArray(sprite.node.verticesUV.innerData.toString().split(' ').map(function (str:String) {
				var out = i % 2 == 0 ? Std.parseInt(str) / w : Std.parseInt(str) / h; 
				i++;
				return out;
			}));

			var vertices:Vector<Float> = Vector.ofArray(sprite.node.vertices.innerData.toString().split(' ').map(Std.parseFloat));
			/**
			//TODO test this instead of map for performance
			 var index = 0, search = -1, lastSearch = 0;
				while ((search = text.indexOf (",", lastSearch)) > -1) {
					indices[index] = Std.parseInt(text.substr(lastSearch, search);
					index++;
				}
			 */
			var oW = sprite.has.oW ? Std.parseInt(sprite.att.oW) : Std.parseInt(sprite.att.w);
			var oH = sprite.has.oH ? Std.parseInt(sprite.att.oH) : Std.parseInt(sprite.att.h);
			var oX = sprite.has.oX ? Std.parseInt(sprite.att.oX) : 0;
			var oY = sprite.has.oY ? Std.parseInt(sprite.att.oY) : 0;
			t.add(sprite.att.n, indices, uv, vertices, 
					oW, oH, 
					new Rectangle(oX, oY, Std.parseInt(sprite.att.w), Std.parseInt(sprite.att.h)));
		}
		return t;
	}
	
	/**
	 * 
	 * @param	json (ARRAY)
	 * @return
	 */
	public static function parseJSON(json:String):TexturePackerParser
	{
		var t = new TexturePackerParser();
		
		var data:TexturePackerPolygon = haxe.Json.parse(json);
		
		t.textureID = data.meta.image;
		var w = data.meta.size.w;
		var h = data.meta.size.h;
		
		
		var indices:Vector<Int> = new Vector<Int>();
		var vertices:Vector<Float> = new Vector<Float>();
		var uv:Vector<Float> = new Vector<Float>();
		
		for (i in 0...data.frames.length)
		{
			var mesh = data.frames[i];
			for (j in 0...mesh.triangles.length)
			{
				for (k in 0...3)
				{
					indices.push(mesh.triangles[j][k]);
				}
				
			}
			
			for (j in 0...mesh.vertices.length)
			{
				for (k in 0...2)
				{
					vertices.push(mesh.vertices[j][k]);
				}
				
			}
				
			for (j in 0...mesh.verticesUV.length)
			{
				for (k in 0...2)
				{
					if (k == 0)
						uv.push(mesh.verticesUV[j][k] / w);
					else
						uv.push(mesh.verticesUV[j][k] / h);
				}
			}
			
			t.add(mesh.filename, indices, uv, vertices, mesh.sourceSize.w, mesh.sourceSize.h, new Rectangle(mesh.spriteSourceSize.x, mesh.spriteSourceSize.y, mesh.spriteSourceSize.w, mesh.spriteSourceSize.h) );
		}
		
		return t;
	}
	
	public function new() 
	{
		super();
	}
	
}