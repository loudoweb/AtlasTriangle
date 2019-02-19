# AtlasTriangle
Allow to use atlas packed with triangles with such tools as [SpriteUV2](https://www.spriteuv.com) or [TexturePacker](https://www.codeandweb.com/texturepacker/) for Haxe language.

# Renderer
Openfl Renderer using graphics.drawTriangles (gpu accelerated)
I'll try to make a renderer using context3d.drawTriangles or directly gl later if it can improve performance or reduce memory footprint

# features
 * Batching (one drawcall per bitmapdata or shader instance)
 * rotation/scale using matrix or not
 * alpha
 * shader
	* GraphicsShader (default : alpha and colorTransform attributes)
	* HueSaturationShader (hue and saturation uniform). You could use this shader to use uniform instead of attributes to change the color of a whole set of triangles
	* GrayScale
	* Invert (invert colors)
	* Pixelated (pixelize the image)
	* Hexagonate (like Pixelated but with hexagonal 'pixels')
 * colorTransform
 * center (for position and rotation)
 * clip (set of mesh that updates depending of fps set)

# TODO
 * improve GraphicsShader to handle better rotation
 * hit test
 * group (wip in other branch)


# Usage
Use SpriteUV2 or TexturePacker to pack your sprites with triangles. This allows to spare some spaces in your atlas and possibly to have smaller atlas.
The more triangles you use, the smallest atlas you'll get. It also means more CPU and less GPU.

With SpriteUV2, please set **Pixel Per Unit** to **1** in the **exportGroup** panel. One more advice with this tool: check **As Single File** option.
SpriteUV2 allows you to set the pivot point for each mesh. By default, it's the center of the original image.

With TexturePacker, use **XML (generic)** exporter and then set **Algorithm** to **Polygon**. I also recommend to set **Extrude** to **0**.
With TexturePacker, the pivot point is the top left of the original image by default. 

You can change the center/pivot point like this: `new SpriteTriangle(mesh, new Point(mesh.oW / 2, mesh.oH /2));`
oW,oH (original width and height of the image source) and bounds (position and size of bounding box) are not available with SpriteUV2 due to lacks of data in the json.



# Example (openfl)
	
	//create the renderer
	renderer = new DrawTrianglesRenderer(this);
	
	//create atlases data
    var data1 = TexturePackerParser.parseXML(Xml.parse(Assets.getText("atlas/atlas1.xml")));
	var data2 = TexturePackerParser.parseXML(Xml.parse(Assets.getText("atlas/atlas2.xml")));
	//add atlas bitmap to renderer
	var img1:BitmapData = Assets.getBitmapData("atlas/atlas1.png");
	var img2:BitmapData = Assets.getBitmapData("atlas/atlas2.png");
	//set name of bitmap used in atlases xml
	renderer.bitmaps.set("atlas1.png", img);
	renderer.bitmaps.set("atlas2.png", img2);
	
	//get meshes (shared data)
	var mesh1 = data.get("mesh1.png");
	var meshes = data2.getClip("mesh_");
	//create sprite (unique sprite. use shared mesh data)
	sprite = new SpriteTriangle(mesh1);
	clip = new ClipTriangle(meshes);
	
	//set the shader (must inherits GraphicsShader)
	//these lines are optional, default shader is already GraphicsShader
	var shader = new GraphicsShader();
	sprite.shader = shader;
	clip.shader = shader;
	
	sprite.x = 120;
	sprite.y = 150;
	sprite.colorTransform = new ColorTransform(0.5);
	
	clip.x = 400;
	clip.y = 150;
	clip.alpha = 0.5;
	
	//add to the display list
	renderer.addChild(sprite);
	renderer.addChild(clip);
	
	//render
	renderer.update(deltaTime);
