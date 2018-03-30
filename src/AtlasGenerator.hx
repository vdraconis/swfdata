package;

import openfl.display.BitmapData;
import openfl.display3D.Context3DTextureFormat;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import swfdata.atlas.AtlasDrawer;
import swfdata.atlas.BitmapTextureAtlas;
import swfdata.atlas.GLSubTexture;
import swfdata.atlas.TextureId;
import swfdata.atlas.TextureSource;
import swfdata.atlas.TextureStorage;
import swfdata.atlas.TextureTransform;

class AtlasGenerator
{
	//var maxRectPacker:MaxRectPacker;
	//var rectangles:Array<PackerRectangle> = new Array<PackerRectangle>();
	
	var atlasDrawer:AtlasDrawer;
	var atlas:BitmapTextureAtlas;
	var textBuffer:TextField = new TextField();
	
	public function new() 
	{
		atlas = new BitmapTextureAtlas(1, 1, 4);
		atlasDrawer = new AtlasDrawer(atlas, 1, 4);
	}
	
	public function setBitmapData(bitmapData:BitmapData)
	{
		atlas.reset(bitmapData);
		atlasDrawer.reset(atlas, 1, 4);
	}
	
	public function addText(text:String, format:TextFormat, id:Int) 
	{
		textBuffer.defaultTextFormat = format;
		textBuffer.autoSize = TextFieldAutoSize.LEFT;
		
		textBuffer.text = text;
		
		var m:Matrix = new Matrix();
		var texture:BitmapData = new BitmapData(Math.ceil(textBuffer.width + 0.5), Math.ceil(textBuffer.height + 0.5), true, 0x0);
		
		textBuffer.textColor = 0xCCCCCC;
		
		m.tx = -1;
		texture.draw(textBuffer, m, null, null, null, true);
		
		m.tx = 1;
		texture.draw(textBuffer, m, null, null, null, true);
		
		m.tx = 0;
		
		m.ty = -1;
		texture.draw(textBuffer, m, null, null, null, true);
		
		m.ty = 1;
		texture.draw(textBuffer, m, null, null, null, true);
		
		textBuffer.textColor = format.color;
		texture.draw(textBuffer, null, null, null, null, true);
		
		//addTexture(texture, id);
	}
	
	public function addTexture(textureStorage:TextureStorage, textureId:TextureId, textureSource:TextureSource, subData:BitmapData, id:Int, scaleX:Float = 1, scaleY:Float = 1)
	{
		var textureTransform = new TextureTransform(scaleX, scaleY, 0, 0);
		atlasDrawer.addShape(id, subData, new Rectangle(0, 0, subData.width * scaleX, subData.height * scaleY), textureTransform, false);
		
		var generatedTexture = atlas.getTexture(id);
		
		var texture:GLSubTexture = new GLSubTexture(textureId, generatedTexture.bounds, textureTransform, textureSource, 4, Context3DTextureFormat.BGRA);
		textureStorage.putTexture(textureId, texture);
	}
}