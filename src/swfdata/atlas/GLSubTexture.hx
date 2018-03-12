package swfdata.atlas;

import openfl.display.BitmapData;
import openfl.display3D.Context3DTextureFormat;
import openfl.geom.Rectangle;
import swfdata.atlas.TextureTransform;

class GLSubTexture implements ITexture
{
	public var id:Int;
	public var bounds:Rectangle;
	public var transform:TextureTransform;
	
	public var textureSource:TextureSource;
	
	public var padding:Int = 0;
	
	public var u:Float = 0;
	public var v:Float = 0;
	
	public var uscale:Float = 1;
	public var vscale:Float = 1;
	
	public var width:Float;
	public var height:Float;
	
	public var pivotX:Float = 0;
	public var pivotY:Float = 0;

	@:access(swfdata)
	public function new(id:Int, bounds:Rectangle, transform:TextureTransform, textureSource:TextureSource, padding:Int, textureFormat:Context3DTextureFormat, scaleFactor:Float = 1) 
	{
		this.id = id;
		this.bounds = bounds;
		this.transform = transform;
		this.textureSource = textureSource;
		this.padding = padding;
		
		width = bounds.width * scaleFactor;
		height = bounds.height * scaleFactor;
		
		u = bounds.x / textureSource.width;
		v = bounds.y / textureSource.height;
		
		uscale = width / textureSource.width;
		vscale = height / textureSource.height;
	}
	
	public function getAlphaAtUV(u:Float, v:Float):Float
	{
		var bitmapData = textureSource.source;
		
        if (bitmapData == null)  
			return 255;
			
		u = (u * width) / textureSource.width;
		v = (v * height) / textureSource.height;
		
		if (Std.is(bitmapData, BitmapData))
			return bitmapData.getPixel32(Std.int((this.u + u) * textureSource.width), Std.int((this.v + v) * textureSource.height)) >> 24 & 0xFF;
		else
		{
			//trace(Std.int(((this.u + u) * textureSource.width) * ((this.v + v) * textureSource.height)) >> 24 & 0xFF);
			return bitmapData.getInt32(Std.int(((this.u + u) * textureSource.width) * ((this.v + v) * textureSource.height))) >> 24 & 0xFF;
		}
        
	}
}