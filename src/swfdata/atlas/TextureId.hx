package swfdata.atlas;

//TODO: may be store id separatly and combine on every set operation is better for pefromance?
abstract TextureId(Int) from Int to Int
{
	public var textureId(get, set):Int;
	public var atlasId(get, set):Int;
	
	public function new(_atlasId:Int = 0, _textureId:Int = 0) 
	{
		this = 0;
		textureId = _textureId;
		atlasId = _atlasId;
	}
	
	public function setData(atlasId:Int, textureiD:Int) 
	{
		
	}
	
	inline public function get_textureId():Int 
	{
		return this >> 16;
	}
	
	inline public function set_textureId(value:Int):Int 
	{
		this = value << 16 | atlasId;
		return value;
	}
	
	inline public function get_atlasId():Int 
	{
		return this & 65535;
	}
	
	inline public function set_atlasId(value:Int):Int 
	{
		this = textureId << 16 | value;
		return value;
	}
	
	public function toString(format:Int = 10):String 
	{
		#if !cpp
		return untyped (this:Int).toString(format);
		#else
		return textureId + ":" + atlasId;
		#end
	}
	
}