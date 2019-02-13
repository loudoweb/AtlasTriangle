package atlasTriangle;

import atlasTriangle.parser.Mesh;
import openfl.Vector;
import atlasTriangle.shaders.GraphicsShader;
import openfl.geom.Point;

/**
 * A SpriteTriangle is made of a shared mesh but have unique x, y, alpha...on screen
 * @author loudo
 */
class SpriteTriangle extends Mesh
{
	public static var DEFAULT_SHADER = new GraphicsShader();
	

	@:isVar public var x(default, set):Float;
	@:isVar public var y(default, set):Float;
	@:isVar public var alpha(default, set):Float;
	@:isVar public var shader(default, set):GraphicsShader;
	@:isVar public var rotation(default, set):Int;
	@:isVar public var center(default, set):Point;
	@:isVar public var pivot(default, set):Point;
	
	public var coor_computed:Vector<Float>;
	public var isDirty:Bool;
	
	public var elapsedTime:Int;
	
	//TODO color, blend, rotation
	
	public function new(mesh:Mesh, center:Point = null, pivot:Point = null) 
	{
		super(mesh.indices, mesh.uv, mesh.coordinates, mesh.textureID);
		this.x = 0;
		this.y = 0;
		this.alpha = 1;
		this.center = center == null ? new Point() : center;
		this.pivot = pivot == null ? new Point() : pivot;
		elapsedTime = 0;
		coor_computed = new Vector<Float>();
		shader = DEFAULT_SHADER;
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
	
	public function set_center(_center:Point):Point
	{
		if (center != _center)
			isDirty = true;
		
		center = _center;

		return _center;
	}
	
	public function set_pivot(_pivot:Point):Point
	{
		if (pivot != _pivot)
			isDirty = true;
		
		pivot = _pivot;

		return _pivot;
	}
	
	public function update(deltaTime:Int):Void
	{
		
		advance(deltaTime);
		compute();
	}
	
	function advance(deltaTime:Int):Void
	{
		elapsedTime += deltaTime;
	}
	
	public function compute():Vector<Float>
	{
		if (isDirty)
		{
			for (i in 0...coordinates.length)
			{
				if(i % 2 == 0)
					coor_computed[i] = coordinates[i] + x - center.x;
				else
					coor_computed[i] = coordinates[i] + y - center.y;
			}
			isDirty = false;
		}
		return coor_computed;
	}
	
}