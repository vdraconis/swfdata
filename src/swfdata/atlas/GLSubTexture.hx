package swfdata.atlas;

import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import swfdata.atlas.TextureTransform;

class GLSubTexture implements ITexture
{
	private var _id:Int;
	private var _bounds:Rectangle;
	private var _transform:TextureTransform;
	
	private var _atlas:GLTextureAtlas;
	
	public var u:Float = 0;
	public var v:Float = 0;
	
	public var uscale:Float = 1;
	public var vscale:Float = 1;
	
	public var width:Float;
	public var height:Float;
	
	public var pivotX:Float = 0;
	public var pivotY:Float = 0;

	@:access(swfdata)
	public function new(id:Int, bounds:Rectangle, transform:TextureTransform, atlas:GLTextureAtlas, scaleFactor:Float = 1) 
	{
		_id = id;
		_bounds = bounds;
		_transform = transform;
		_atlas = atlas;
		
		width = _bounds.width * scaleFactor;
		height = _bounds.height * scaleFactor;
		
		u = _bounds.x / atlas.atlasData.width;
		v = _bounds.y / atlas.atlasData.height;
		
		uscale = width / atlas.atlasData.width;
		vscale = height / atlas.atlasData.height;
	}
	
	public function getAlphaAtUV(u:Float, v:Float):Float
	{
		var bitmapData:BitmapData = _atlas.atlasData;
		
        if (bitmapData == null)  
			return 255;
			
		u = (u * width) / bitmapData.width;
		v = (v * height) / bitmapData.height;
		
        return bitmapData.getPixel32(Std.int((this.u + u) * bitmapData.width), Std.int((this.v + v) * bitmapData.height)) >> 24 & 0xFF;
	}
	
	public function getU(u:Float):Int {
		var bitmapData:BitmapData = _atlas.atlasData;
		u = (u * width) / bitmapData.width;
		return Std.int((this.u + u) * bitmapData.width);
	}
	
	public function getV(v:Float):Int {
		var bitmapData:BitmapData = _atlas.atlasData;
		v = (v * height) / bitmapData.height;
		return Std.int((this.v + v) * bitmapData.height);
	}
	
	public var id(get, never):Int;
	
	function get_id():Int 
	{
		return _id;
	}
	
	public var transform(get, never):TextureTransform;
	
	function get_transform():TextureTransform 
	{
		return _transform;
	}
	
	public var bounds(get, never):Rectangle;
	
	function get_bounds():Rectangle 
	{
		return _bounds;
	}
}