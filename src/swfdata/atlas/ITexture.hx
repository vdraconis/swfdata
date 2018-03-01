package swfdata.atlas;

import openfl.geom.Rectangle;
import swfdata.atlas.TextureTransform;

interface ITexture
{
    public var id:Int;    
    public var transform:TextureTransform;    
    public var bounds:Rectangle;
}