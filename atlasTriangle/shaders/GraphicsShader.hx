package atlasTriangle.shaders;

import openfl.utils.ByteArray;
import openfl.display.Shader;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
/**
 * cloned from openfl.display.GraphicsShader
 * This cloned shader allow us more possibilities (attributes are not overwritten)
 * changed: name of attributes from openfl_ prefix to triangle_
 * @author jgranick
 */
class GraphicsShader extends openfl.display.GraphicsShader
{
		
	@:glVertexSource("
	
		attribute float triangle_Alpha;
		attribute vec4 triangle_ColorMultiplier;
		attribute vec4 triangle_ColorOffset;
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		
		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;
		
		uniform mat4 openfl_Matrix;
		uniform bool triangle_HasColorTransform;
		uniform vec2 openfl_TextureSize;
		
		void main(void) {
			
			openfl_Alphav = triangle_Alpha;
			openfl_TextureCoordv = openfl_TextureCoord;
			
			if (triangle_HasColorTransform) {
				
				openfl_ColorMultiplierv = triangle_ColorMultiplier;
				openfl_ColorOffsetv = triangle_ColorOffset / 255.0;
				
			}
			
			gl_Position = openfl_Matrix * openfl_Position;
			
		}")
		

	@:glFragmentSource("
	
		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;
		
		uniform bool triangle_HasColorTransform;
		uniform vec2 openfl_TextureSize;
		uniform sampler2D bitmap;
		
		void main(void) {
			
			vec4 color = texture2D (bitmap, openfl_TextureCoordv);
		
			if (color.a == 0.0) {
				
				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
				
			} else if (triangle_HasColorTransform) {
				
				color = vec4 (color.rgb / color.a, color.a);
				
				mat4 colorMultiplier = mat4 (0);
				colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
				colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
				colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
				colorMultiplier[3][3] = openfl_ColorMultiplierv.w;
				
				color = clamp (openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
				
				if (color.a > 0.0) {
					
					gl_FragColor = vec4 (color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
					
				} else {
					
					gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
					
				}
				
			} else {
				
				gl_FragColor = color * openfl_Alphav;
				
			}
			
		}"
	)
	public function new(code:ByteArray = null)
	{
		super(code);
	}
}
