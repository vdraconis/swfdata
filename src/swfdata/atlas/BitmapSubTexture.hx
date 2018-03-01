package swfdata.atlas;

import openfl.geom.Rectangle;
import swfdata.atlas.ITexture;
import swfdata.atlas.TextureTransform;

class BitmapSubTexture implements ITexture
{
    public var id:Int;
    public var bounds:Rectangle;
	public var transform:TextureTransform;
    
    public function new(id:Int, bounds:Rectangle, transform:TextureTransform)
    {
        this.bounds = bounds;
        this.id = id;
        this.transform = transform;
    }
}