package atlasTriangle.shaders;

import openfl.utils.ByteArray;

/**
 * Renders the image using a pattern of hexagonal tiles.
 * Tile colors are nearest-neighbor sampled from the centers of the tiles.
 * 
 * @param center The x and y coordinates of the pattern center.
 * @param scale   The width of an individual tile, in pixels.
 * 
 * @author Evan Wallace https://github.com/evanw/glfx.js/blob/master/src/filters/fun/hexagonalpixelate.js
 * @author adapted by loudo
 */
class Hexagonate extends GraphicsShader
{

	@:glFragmentSource(
		"#pragma header
        uniform vec2 center;
		uniform vec2 texSize;
        uniform float scale;
       

        void main(void) {
			
            vec2 tex = (openfl_TextureCoordv * texSize - center) / scale;
            tex.y /= 0.866025404;
            tex.x -= tex.y * 0.5;
		
            
            vec2 a;
            if (tex.x + tex.y - floor(tex.x) - floor(tex.y) < 1.0) a = vec2(floor(tex.x), floor(tex.y));
            else a = vec2(ceil(tex.x), ceil(tex.y));
            vec2 b = vec2(ceil(tex.x), floor(tex.y));
            vec2 c = vec2(floor(tex.x), ceil(tex.y));
            
            vec3 TEX = vec3(tex.x, tex.y, 1.0 - tex.x - tex.y);
            vec3 A = vec3(a.x, a.y, 1.0 - a.x - a.y);
            vec3 B = vec3(b.x, b.y, 1.0 - b.x - b.y);
            vec3 C = vec3(c.x, c.y, 1.0 - c.x - c.y);
            
            float alen = length(TEX - A);
            float blen = length(TEX - B);
            float clen = length(TEX - C);
            
            vec2 choice;
            if (alen < blen) {
                if (alen < clen) choice = a;
                else choice = c;
            } else {
                if (blen < clen) choice = b;
                else choice = c;
            }
            
            choice.x += choice.y * 0.5;
            choice.y *= 0.866025404;
            choice *= scale / texSize;
            gl_FragColor = texture2D(bitmap, choice + center / texSize);
		}"
	)
	
	
	public function new(scale:Float = 0.15, center:Int = 0 ) 
	{
		super();
		
		data.scale.value = [scale];
		data.center.value = [center, center];
		data.texSize.value = [100,100];//should be Sprite size
	}
	
}