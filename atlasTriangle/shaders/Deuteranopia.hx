package atlasTriangle.shaders;
import atlasTriangle.shaders.GraphicsShader;
/**
 * ...
 * @author loudo
 */
class Deuteranopia extends GraphicsShader
{
	
	@:glFragmentSource(
		"#pragma header
		const mat4 mDeuteranopia = mat4( 0.43 ,  0.72 , -0.15 ,  0.0 ,
									 0.34 ,  0.57 ,  0.09 ,  0.0 ,
									-0.02 ,  0.03 ,  1.00 ,  0.0 ,
									 0.0  ,  0.0  ,  0.0  ,  1.0 );
		
		void main(void) {
			
			gl_FragColor = mDeuteranopia * texture2D(bitmap, openfl_TextureCoordv);
			gl_FragColor = gl_FragColor * openfl_Alphav;
			
		}"
	)
	
	public function new()
	{
		super();
	}
	
}