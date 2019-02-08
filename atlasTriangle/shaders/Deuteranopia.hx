package atlasTriangle.shaders;
import openfl.display.GraphicsShader;

/**
 * ...
 * @author loudo
 */
class Deuteranopia extends GraphicsShader
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
		const mat4 mDeuteranopia = mat4( 0.43 ,  0.72 , -0.15 ,  0.0 ,
									 0.34 ,  0.57 ,  0.09 ,  0.0 ,
									-0.02 ,  0.03 ,  1.00 ,  0.0 ,
									 0.0  ,  0.0  ,  0.0  ,  1.0 );
		
		void main(void) {
			
			#pragma body
			
			gl_FragColor = mDeuteranopia * texture2D(bitmap, openfl_TextureCoordv);
			gl_FragColor = gl_FragColor * alphav;
			
		}"
	)
	
	public function new()
	{
		super();
	}
	
}