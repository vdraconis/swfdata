package swfdata.atlas;

import openfl.geom.Rectangle;

interface ITextureAtlas
{
    var padding(get, set) : Int;

    /**
		 * put sub-texture in to atlas by specified id (ITexture.id)
		 * @param	texture
		 */
    function putTexture(texture : ITexture) : Void;
    
    /**
		 * return sub-texture from atlas by specified id
		 * @param	textureId
		 * @return
		 */
    function getTexture(textureId : Int) : ITexture;
    
    function createSubTexture(id : Int, region : Rectangle, scaleX : Float, scaleY : Float) : ITexture;
}

