package swfdata.atlas;

import openfl.display.BitmapData;
import openfl.display3D.Context3DTextureFormat;
import openfl.display3D.textures.Texture;
import renderer.TextureManager;

class TextureSource 
{
	public var source:BitmapData;
	public var glData:Texture;
	var textureManager:TextureManager;

	public function new(source:BitmapData, textureManager:TextureManager) 
	{
		this.textureManager = textureManager;
		this.source = source;
	}
	
	public function createGlData(format:Context3DTextureFormat)
	{
		glData = textureManager.createTexture(0, source, format);
	}
	
	public function deleteGlData()
	{
		glData.dispose();
	}
	
	public function uploadToGpu()
	{
		glData.uploadFromBitmapData(source, 0);
	}
}