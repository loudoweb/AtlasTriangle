# AtlasTriangle
Allow to use atlas packed with triangles with such tools as **SpriteUV2** or **TexturePacker** for Haxe language.

# Render
For now, there is no renderer included (TODO).

# Usage
Use SpriteUV2 or TexturePacker to pack your sprites with triangles. This allows to spare some spaces in your atlas and possibly to have smaller atlas.
The more triangles you use, the smallest atlas you'll get. It also means more CPU and less GPU.

With SpriteUV2, please set **Pixel Per Unit** to **1** in the **exportGroup** panel. One more advice with this tool: check **As Single File** option.

With TexturePacker, use **XML (generic)** exporter and then set **Algorithm** to **Polygon**. I also recommend to set **Extrude** to **0**.

# Example (openfl)

    var data:SpriteUVParser = new SpriteUVParser(Assets.getText('atlas/atlas.json'));
		var data2:TexturePackerParser = new TexturePackerParser(Xml.parse(Assets.getText('atlas/atlas2.xml')), 4096);
		
		var img = Assets.getBitmapData("atlas/atlas.png");
		var img2 = Assets.getBitmapData("atlas/atlas2.png");
		
		var mesh = data.get("image01");
		var mesh2 = data2.get("image02.png");
		
		graphics.beginBitmapFill(img, null, false, true);
		graphics.drawTriangles(mesh.coordinates.map(function(f:Float):Float { return f + 100; } ), mesh.indices, mesh.uv);
		graphics.beginBitmapFill(img2, null, false, true);
		graphics.drawTriangles(mesh2.coordinates.map(function(f:Float):Float { return f + 250; } ), mesh2.indices, mesh2.uv);
		graphics.endFill();
