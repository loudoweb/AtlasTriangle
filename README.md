# AtlasTriangle
Allow to use atlas packed with triangles with such tools as [SpriteUV2](https://www.spriteuv.com) or [TexturePacker](https://www.codeandweb.com/texturepacker/) for Haxe language.

# Render
For now, there is no renderer included (TODO).

# Usage
Use SpriteUV2 or TexturePacker to pack your sprites with triangles. This allows to spare some spaces in your atlas and possibly to have smaller atlas.
The more triangles you use, the smallest atlas you'll get. It also means more CPU and less GPU.

With SpriteUV2, please set **Pixel Per Unit** to **1** in the **exportGroup** panel. One more advice with this tool: check **As Single File** option.

With TexturePacker, use **XML (generic)** exporter and then set **Algorithm** to **Polygon**. I also recommend to set **Extrude** to **0**.

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
	var mesh2 = data2.get("mesh2.png");
	//create sprite (unique sprite. use shared mesh data)
	sprite1 = new SpriteTriangle(mesh1);
	sprite2 = new SpriteTriangle(mesh2);
	
	//set the shader (must inherits GraphicsShader)
	//these lines are optional, default shader is already GraphicsShader
	var shader = new GraphicsShader();
	sprite1.shader = shader;
	sprite2.shader = shader;
	
	sprite1.x = 120;
	sprite1.y = 150;
	
	sprite2.x = 400;
	sprite2.y = 150;
	sprite2.alpha = 0.5;
	
	//add to the display list
	renderer.addChild(sprite);
	renderer.addChild(sprite2);
	
	//render
	renderer.update();
