package atlasTriangle;

import atlasTriangle.parser.Mesh;
import openfl.Vector;

/**
 * ...
 * @author loudo
 */
class SpriteTriangle extends Mesh
{
	
	public var isDirty:Bool;

	@:isVar public var x(default, set):Float;
	@:isVar public var y(default, set):Float;
	public var coor_computed:Vector<Float>;
	
	public var rotation:Int;
	
	//TODO color, blend, shader
	
	public function new(mesh:Mesh) 
	{
		super(mesh.indices.copy(), mesh.uv.copy(), mesh.coordinates.copy(), mesh.textureID);
		coor_computed = new Vector<Float>();
		x = 0;
		y = 0;
	}
	
	public function set_x(_x:Float):Float
	{
		if (x != _x)
			isDirty = true;
			
		x = _x;

		return _x;
	}
	
	public function set_y(_y:Float):Float
	{
		if (y != _y)
			isDirty = true;
		
		y = _y;

		return _y;
	}
	
	public function compute():Vector<Float>
	{
		if (isDirty)
		{
			for (i in 0...coordinates.length)
			{
				if(i % 2 == 0)
					coor_computed[i] = coordinates[i] + x;
				else
					coor_computed[i] = coordinates[i] + y;
			}
			isDirty = false;
		}
		return coor_computed;
	}
	
}