package swfdata.atlas;

import openfl.display.BitmapData;
import openfl.display3D.textures.Texture;
import openfl.geom.Rectangle;
import renderer.TextureManager;
import swfdata.atlas.ITexture;

class GLTextureAtlas implements ITextureAtlas
{	
	@:isVar 
	public var padding(get, set):Int;
	public var atlasData:BitmapData;
	public var gpuData:Texture;

	var texturesCount:Int = 0;
	var subTextures:Map<Int, ITexture> = new Map<Int, ITexture>();
	var id:String;
	var format:String;
	
	public function new(id:String, atlasData:BitmapData, format:String, padding:Int = 0)
	{
		this.padding = padding;
		this.format = format;
		this.atlasData = atlasData;
		this.id = id;
		
		uploadToGpu();
	}
	
	public function uploadToGpu():Void
	{
		gpuData = TextureManager.createTexture(id, atlasData, format);
		gpuData.uploadFromBitmapData(atlasData, 0);
	}
	
	function get_padding():Int 
	{
		return padding;
	}
	
	function set_padding(value:Int):Int 
	{
		return padding = value;
	}
	
	public function putTexture(texture:ITexture):Void 
	{
		texturesCount++;
        subTextures.set(texture.id, texture);
	}
	
	public function getTexture(textureId:Int):ITexture 
	{
		return subTextures.get(textureId);
	}
	
	public function createSubTexture(id:Int, region:Rectangle, scaleX:Float, scaleY:Float):ITexture 
	{
		var subTexture:GLSubTexture = new GLSubTexture(id, region, new TextureTransform(scaleX, scaleY), this);
        putTexture(subTexture);
		
		return subTexture;
	}
	
	public function createSubTexture2(id:Int, region:Rectangle, scaleX:Float, scaleY:Float, scaleFactor:Float) 
	{
		var subTexture:GLSubTexture = new GLSubTexture(id, region, new TextureTransform(scaleX, scaleY), this, scaleFactor);
        putTexture(subTexture);
		
		return subTexture;
	}
}