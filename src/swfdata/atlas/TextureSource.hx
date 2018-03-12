package swfdata.atlas;

import openfl.display.BitmapData;
import openfl.display3D.Context3DTextureFormat;
import openfl.display3D.textures.Texture;
import renderer.TextureManager;

class TextureSource 
{
	public var source:Dynamic;
	public var glData:Texture;
	
	public var width:Int;
	public var height:Int;
	
	var textureManager:TextureManager;
	
	public function new(source:Dynamic, width:Int, height:Int, textureManager:TextureManager) 
	{
		this.height = height;
		this.width = width;
		this.textureManager = textureManager;
		this.source = source;
	}
	
	public function createGlData(format:Context3DTextureFormat)
	{
		glData = textureManager.createTexture(0, width, height, format);
	}
	
	public function deleteGlData()
	{
		glData.dispose();
	}
	
	public function uploadToGpu()
	{
		if(Std.is(source, BitmapData))
			glData.uploadFromBitmapData(source, 0);
		else
			glData.uploadFromByteArray(source, 0);
	}
}