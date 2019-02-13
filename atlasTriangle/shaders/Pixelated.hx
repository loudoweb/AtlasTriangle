package atlasTriangle.shaders;

import atlasTriangle.shaders.GraphicsShader;

/**
 * @author Agnius Vasiliauskas
 * @author adapted by Loudo
 */
class Pixelated extends GraphicsShader
{
	
	@:glFragmentSource(
		"#pragma header
		uniform float pixelization;
		
		void main(void) {
			
			float dx = 15.*(1. / pixelization);
			float dy = 10.*(1. / pixelization);
			
			vec2 coord = vec2(dx*floor(openfl_TextureCoordv.x/dx),
							   dy * floor(openfl_TextureCoordv.y / dy));
							   
			gl_FragColor = texture2D(bitmap, coord);
			gl_FragColor = gl_FragColor * openfl_Alphav;
			
		}"
	)
	
	public function new(pixelization:Float = 8192.0)
	{
		super();
		data.pixelization.value = [pixelization];//higher is smaller pixels
	}
}