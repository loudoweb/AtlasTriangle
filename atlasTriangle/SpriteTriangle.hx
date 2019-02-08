package atlasTriangle;

import atlasTriangle.parser.Mesh;
import openfl.Vector;
import openfl.display.GraphicsShader;

/**
 * ...
 * @author loudo
 */
class SpriteTriangle extends Mesh
{
	
	

	@:isVar public var x(default, set):Float;
	@:isVar public var y(default, set):Float;
	@:isVar public var alpha(default, set):Float;
	@:isVar public var shader(default, set):GraphicsShader;
	@:isVar public var rotation(default, set):Int;
	
	public var coor_computed:Vector<Float>;
	public var isDirty:Bool;
	
	//TODO color, blend, shader
	
	public function new(mesh:Mesh) 
	{
		super(mesh.indices.copy(), mesh.uv.copy(), mesh.coordinates.copy(), mesh.textureID);
		coor_computed = new Vector<Float>();
		x = 0;
		y = 0;
		alpha = 1;
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
	
	public function set_alpha(_alpha:Float):Float
	{
		if (alpha != _alpha)
			isDirty = true;
		
		alpha = _alpha;
		
		return _alpha;
	}
	
	public function set_shader(_shader:GraphicsShader):GraphicsShader
	{
		if (shader != _shader)
			isDirty = true;
		
		shader = _shader;

		return _shader;
	}
	
	public function set_rotation(_rotation:Int):Int
	{
		if (rotation != _rotation)
			isDirty = true;
		
		rotation = _rotation;

		return _rotation;
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