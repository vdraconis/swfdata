package swfdata.atlas;

import swfdata.atlas.TextureTransform;

import flash.geom.Rectangle;
class Subtexture
{
    public var bounds : Rectangle;
    public var id : Int;
    public var transform : TextureTransform;
    
    public function new(id : Int, bounds : Rectangle, scaleX : Float, scaleY : Float)
    {
        this.bounds = bounds;
        this.id = id;
        transform = new TextureTransform(scaleX, scaleY);
    }
}
