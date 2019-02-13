package atlasTriangle.shaders;

import openfl.utils.ByteArray;

/**
 * @description   Simulates a black and white halftone rendering of the image by multiplying
 *                pixel values with a rotated 2D sine wave pattern.
 * @param center The x and y coordinates of the pattern origin.
 * @param angle   The rotation of the pattern in radians.
 * @param size    The diameter of a dot in pixels.
 * @author Evan Wallace https://github.com/evanw/glfx.js/blob/master/src/filters/fun/dotscreen.js
 * @author loudo
 */
class DotScreen extends GraphicsShader
{

	@:glFragmentSource(
		"#pragma header
		uniform vec2 center;
        uniform float angle;
        uniform float scale;
        uniform vec2 texSize;
		
		float pattern() {
            float s = sin(angle), c = cos(angle);
            vec2 tex = openfl_TextureCoordv * texSize - center;
            vec2 point = vec2(
                c * tex.x - s * tex.y,
                s * tex.x + c * tex.y
            ) * scale;
            return (sin(point.x) * sin(point.y)) * 4.0;
        }
		
		void main(void) {
			
			vec4 color = texture2D(bitmap, openfl_TextureCoordv);
            float average = (color.r + color.g + color.b) / 3.0;
            gl_FragColor = vec4(vec3(average * 10.0 - 5.0 + pattern()), color.a);
			
		}"
	)
	
	public function new(size:Int = 1, angle:Float = 0) 
	{
		super();
		data.scale.value = [Math.PI / size];
		data.angle.value = [angle];
		data.center.value = [0,0];
		data.texSize.value = [400,400];//should be Sprite size
	}
	
}