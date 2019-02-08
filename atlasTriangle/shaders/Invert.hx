package atlasTriangle.shaders;

import openfl.display.GraphicsShader;

/**
 * ...
 * @author MrCdK
 * @author adapted by Loudo
 */
class Invert extends GraphicsShader
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
		
		void main(void) {
			
			#pragma body
			
			gl_FragColor = vec4(1.0 - gl_FragColor.r, 1.0 - gl_FragColor.g, 1.0 - gl_FragColor.b, gl_FragColor.a);
			gl_FragColor = gl_FragColor * alphav;
			
		}"
	)
	
	public function new()
	{
		super();
	}
}