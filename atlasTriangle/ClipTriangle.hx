package atlasTriangle;
import atlasTriangle.parser.Mesh;
import openfl.Vector;

/**
 * A ClipTriangle is an animated SpriteTriangle
 * @author loudo
 */
class ClipTriangle extends SpriteTriangle
{
	var _meshes:Array<Mesh>;
	
	public var fps:Int;
	var _lastFrame:Int;
	
	
	public function new(meshes:Array<Mesh>, fps:Int = 12) 
	{
		_meshes = meshes;
		this.fps = fps;
		this.elapsedTime = 0;
		_lastFrame = -1;
		
		super(_meshes[0]);
	}
	
	override public function update(deltaTime:Int):Void
	{
		super.update(deltaTime);
		
		var frame =  Math.floor((elapsedTime / 1000) * fps) % _meshes.length;
				
		if (_lastFrame != frame)
		{
			isDirty = true;
			_lastFrame = frame;
						
			//update current mesh
			var current = _meshes[frame];
			coordinates = current.coordinates;
			indices = current.indices;
			uv = current.uv;
			textureID = current.textureID;
		}
		
		
		
		
	}
	
}