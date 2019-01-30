package atlasTriangle.shaders;

import openfl.display.GraphicsShader;
/**
 * @author jgranick
 */
class AlphaGraphicsShader extends GraphicsShader {
	
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
			gl_FragColor = gl_FragColor * alphav;
			
		}"
	)
	
	public function new () {
		super ();
	}
	
}