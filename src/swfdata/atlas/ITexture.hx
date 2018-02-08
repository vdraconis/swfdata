package swfdata.atlas;

import openfl.geom.Rectangle;
import swfdata.atlas.TextureTransform;

interface ITexture
{
    var id(get, never):Int;    
    var transform(get, never):TextureTransform;    
    var bounds(get, never):Rectangle;
}