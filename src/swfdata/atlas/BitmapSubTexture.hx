package swfdata.atlas;

import swfdata.atlas.ITexture;
import swfdata.atlas.TextureTransform;

import flash.geom.Rectangle;

class BitmapSubTexture implements ITexture
{
    public var id(get, never) : Int;
    public var transform(get, never) : TextureTransform;
    public var bounds(get, never) : Rectangle;

    private var _bounds : Rectangle;
    private var _id : Int;
	
	@:allow(swfdata)
    private var _transform : TextureTransform;
    
    public function new(id : Int, bounds : Rectangle, transform : TextureTransform)
    {
        _bounds = bounds;
        _id = id;
        _transform = transform;
    }
    
    /* INTERFACE swfdata.atlas.ITexture */
    
    private function get_id() : Int
    {
        return _id;
    }
    
    private function get_transform() : TextureTransform
    {
        return _transform;
    }
    
    private function get_bounds() : Rectangle
    {
        return _bounds;
    }
}
