package atlasTriangle;

import atlasTriangle.parser.Mesh;
import openfl.Vector;
import atlasTriangle.shaders.GraphicsShader;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;

/**
 * A SpriteTriangle is made of a shared mesh but have unique x, y, alpha...on screen
 * @author loudo
 * @author some code from openfl
 */
class SpriteTriangle extends Mesh
{
	public static var DEFAULT_SHADER = new GraphicsShader();
	

	public var x(get, set):Float;
	public var y(get, set):Float;
	@:isVar public var alpha(default, set):Float;
	@:isVar public var shader(default, set):GraphicsShader;
	@:isVar public var center(default, set):Point;
	@:isVar public var matrix(default, set):Matrix;
	@:isVar public var colorTransform (default, set):ColorTransform;
	public var parent(default, null):GroupTriangle;
	public var rotation(get, set):Null<Float>;
	public var scaleX(get, set):Null<Float>;
	public var scaleY(get, set):Null<Float>;
	
	public var isDirty:Bool;
	
	public var elapsedTime:Int;
	
	private var __rotationCosine:Float;
	private var __rotationSine:Float;
	private var __rotation:Null<Float>;
	private var __scaleX:Null<Float>;
	private var __scaleY:Null<Float>;
	
	//TODO blend
	//TODO pool
	
	public function new(mesh:Mesh, center:Point = null) 
	{
		if (mesh != null)
			super(mesh.indices, mesh.uv, mesh.coordinates, mesh.textureID, mesh.oW, mesh.oH, mesh.bounds);
		else
			super(null, null, null, "");
		
		this.matrix = new Matrix();
		alpha = 1;
		this.center = center == null ? new Point() : center;
		
		elapsedTime = 0;
		shader = DEFAULT_SHADER;
	}
	
	public function get_x():Float
	{
		return matrix.tx;
	}
	
	public function set_x(value:Float):Float
	{
		if (x != value)
		{
			matrix.tx = value;
			__setRenderDirty();
		}

		return value;
	}
	
	public function get_y():Float
	{
		return matrix.ty;
	}
	
	public function set_y(value:Float):Float
	{
		if (y != value)
		{
			matrix.ty = value;
			__setRenderDirty();
		}

		return value;
	}
	
	public function set_alpha(value:Float):Float
	{
		if (alpha != value)
		{
			alpha = value;
			__setRenderDirty();
		}
		
		return value;
	}
	
	public function set_shader(value:GraphicsShader):GraphicsShader
	{
		if (shader != value)
		{
			shader = value;
			__setRenderDirty();
		}

		return value;
	}
	
	private function get_rotation ():Float {
		
		if (__rotation == null) {
			
			if (matrix.b == 0 && matrix.c == 0) {
				
				__rotation = 0;
				__rotationSine = 0;
				__rotationCosine = 1;
				
			} else {
				
				var radians = Math.atan2 (matrix.d, matrix.c) - (Math.PI / 2);
				
				__rotation = radians * (180 / Math.PI);
				__rotationSine = Math.sin (radians);
				__rotationCosine = Math.cos (radians);
				
			}
			
		}
		
		return __rotation;
		
	}
	
	public function set_rotation(value:Float):Float
	{
		if (__rotation != value)
		{
			__rotation = value;

			var radians = value * (Math.PI / 180);
			__rotationSine = Math.sin (radians);
			__rotationCosine = Math.cos (radians);
			
			var __scaleX = this.scaleX;
			var __scaleY = this.scaleY;
			
			matrix.a = __rotationCosine * __scaleX;
			matrix.b = __rotationSine * __scaleX;
			matrix.c = -__rotationSine * __scaleY;
			matrix.d = __rotationCosine * __scaleY;
			
			__setRenderDirty();
		}

		return value;
	}
	
	private function get_scaleX ():Float {
		
		if (__scaleX == null) {
			
			if (matrix.b == 0) {
				
				__scaleX = matrix.a;
				
			} else {
				
				__scaleX = Math.sqrt (matrix.a * matrix.a + matrix.b * matrix.b);
				
			}
			
		}
		
		return __scaleX;
		
	}
	
	public function set_scaleX(value:Float):Float
	{
		if (__scaleX != value)
		{
			__scaleX = value;
			
			if (matrix.b == 0) {
				
				matrix.a = value;
				
			} else {
				
				var rotation = this.rotation;
				
				var a = __rotationCosine * value;
				var b = __rotationSine * value;
				
				matrix.a = a;
				matrix.b = b;
				
			}
			__setRenderDirty();
		}

		return value;
	}
	
	private function get_scaleY ():Float {
		
		if (__scaleY == null) {
			
			if (matrix.c == 0) {
				
				__scaleY = matrix.d;
				
			} else {
				
				__scaleY = Math.sqrt (matrix.c * matrix.c + matrix.d * matrix.d);
				
			}
			
		}
		
		return __scaleY;
		
	}
	
	public function set_scaleY(value:Float):Float
	{
		if (__scaleY != value)
		{
			__scaleY = value;
			
			if (matrix.c == 0) {
				
				matrix.d = value;
				
			} else {
				
				var rotation = this.rotation;
				
				var c = -__rotationSine * value;
				var d = __rotationCosine * value;
				
				matrix.c = c;
				matrix.d = d;
				
			}
			__setRenderDirty();
		}

		return value;
	}
	
	public function set_matrix(value:Matrix):Matrix
	{
		if (matrix != value)
		{
			matrix = value;
			__rotation = null;
			__scaleX = null;
			__scaleY = null;
			__setRenderDirty();
		}
		
		

		return value;
	}
	
	public function set_center(value:Point):Point
	{
		if (center != value)
		{
			center = value;
			__setRenderDirty();
		}

		return value;
	}
	
	public function set_colorTransform(value:ColorTransform):ColorTransform
	{
		if (colorTransform != value)
		{
			colorTransform = value;
			__setRenderDirty();
		}

		return value;
	}
	
	public function update(deltaTime:Int):Void
	{
		
		elapsedTime += deltaTime;
		isDirty = false;
	}
	
	@:noCompletion private function __setRenderDirty():Void
	{
		if (!isDirty)
		{
			isDirty = true;

			if (parent != null)
			{
				parent.__setRenderDirty();
			}
		}
	}
	
}