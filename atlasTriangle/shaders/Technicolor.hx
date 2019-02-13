package atlasTriangle.shaders;
import atlasTriangle.shaders.GraphicsShader;
/**
 * Technicolor Shader
 * Simulates the look of the two-strip technicolor process popular in early 20th century films.
 * More historical info here: http://www.widescreenmuseum.com/oldcolor/technicolor1.htm
 * Demo here: http://charliehoey.com/technicolor_shader/shader_test.html
 * @author flimshaw
 * @author adapted by loudo
 */
class Technicolor extends GraphicsShader
{
	
	@:glFragmentSource(
		"#pragma header
		
		void main(void) {
			
			gl_FragColor = texture2D(bitmap, openfl_TextureCoordv);
			gl_FragColor = vec4(gl_FragColor.r, (gl_FragColor.g + gl_FragColor.b) * .5, (gl_FragColor.g + gl_FragColor.b) * .5, gl_FragColor.a);
			gl_FragColor = gl_FragColor * openfl_Alphav;
			
		}"
	)
	
	public function new()
	{
		super();
	}
	
}