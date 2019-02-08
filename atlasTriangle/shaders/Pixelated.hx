package atlasTriangle.shaders;

import openfl.display.GraphicsShader;

/**
 * @author Agnius Vasiliauskas
 * @author adapted by Loudo
 */
class Pixelated extends GraphicsShader
{
	@:glVertexSource(
		"#pragma header
		attribute float alpha;
		varying float alphav;
		
		void main(void) {
			
			alphav = alpha;
			#pragma body
			
		}"
	)
	
	@:glFragmentSource(
		"#pragma header
		varying float alphav;
		const float pixelization = 8192.;//higher is smaller pixels
		
		void main(void) {
			
			#pragma body
			
			float dx = 15.*(1. / pixelization);
			float dy = 10.*(1. / pixelization);
			
			vec2 coord = vec2(dx*floor(openfl_TextureCoordv.x/dx),
							   dy * floor(openfl_TextureCoordv.y / dy));
							   
			gl_FragColor = texture2D(bitmap, coord);
			
		}"
	)
	
	public function new()
	{
		super();
	}
}