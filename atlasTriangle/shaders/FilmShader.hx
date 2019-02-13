package atlasTriangle.shaders;

import openfl.utils.ByteArray;

/**
 * 
 * * Film grain & scanlines shader
 *
 * - ported from HLSL to WebGL / GLSL
 * http://www.truevision3d.com/forums/showcase/staticnoise_colorblackwhite_scanline_shaders-t18698.0.html
 *
 * Screen Space Static Postprocessor
 *
 * Produces an analogue noise overlay similar to a film grain / TV static
 *
 * Original implementation and noise algorithm
 * Pat 'Hawthorne' Shearon
 *
 * Optimized scanlines + noise version with intensity scaling
 * Georg 'Leviathan' Steinrohder
 *
 * This version is provided under a Creative Commons Attribution 3.0 License
 * http://creativecommons.org/licenses/by/3.0/
 * 
 * @author alteredq https://github.com/mrdoob/three.js/blob/master/examples/js/shaders/FilmShader.js
 * @author adapted by loudo
 */
class FilmShader extends GraphicsShader
{

	@:glFragmentSource(
		"#pragma header
		// control parameter
		uniform float uTime;

		uniform bool grayscale;

		// noise effect intensity value (0 = no effect, 1 = full effect)
		uniform float nIntensity;

		// scanlines effect intensity value (0 = no effect, 1 = full effect)
		uniform float sIntensity;

		// scanlines effect count value (0 = no effect, 4096 = full effect)
		uniform float sCount;
		
		float rand(vec2 co){
			return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
		}
		
		void main(void) {

			// sample the source
			vec4 cTextureScreen = texture2D( bitmap, openfl_TextureCoordv );

			// make some noise
			float dx = rand( openfl_TextureCoordv + uTime);

			// add noise
			vec3 cResult = cTextureScreen.rgb + cTextureScreen.rgb * clamp( 0.1 + dx, 0.0, 1.0 );

			// get us a sine and cosine
			vec2 sc = vec2( sin( openfl_TextureCoordv.y * sCount ), cos( openfl_TextureCoordv.y * sCount ) );

			// add scanlines
			cResult += cTextureScreen.rgb * vec3( sc.x, sc.y, sc.x ) * sIntensity;

			// interpolate between source and result by intensity
			cResult = cTextureScreen.rgb + clamp( nIntensity, 0.0,1.0 ) * ( cResult - cTextureScreen.rgb );

			// convert to grayscale if desired
			if( grayscale ) {

				cResult = vec3( cResult.r * 0.3 + cResult.g * 0.59 + cResult.b * 0.11 );

			}

			gl_FragColor =  vec4( cResult, cTextureScreen.a );

		}"
	
	)
	
	public function new() 
	{
		super();
		
		data.uTime.value = [0];
		data.nIntensity.value = [0.5];
		data.sIntensity.value = [0.05];
		data.sCount.value = [4096];
		data.grayscale.value = [0];
		
	}
	
}