package swfdata.atlas;

class TextureStorage 
{
	private var textures:Map<TextureId, ITexture> = new Map();
	private var currentTexure:ITextureAtlas;
	private var currentTextureId:Int = 0;
	
	public function new() 
	{
		
	}
	
	inline public function getTexture(id:TextureId)
	{
		return textures.get(id);
	}
	
	inline public function putTexture(id:TextureId, texture:ITexture)
	{
		textures.set(id, texture);
	}
	
	inline public function getNextTextureId():Int 
	{
		return currentTextureId++;
	}
}