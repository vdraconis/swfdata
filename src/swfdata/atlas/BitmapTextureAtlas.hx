package swfdata.atlas;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import swfdata.atlas.ITexture;
import swfdata.atlas.ITextureAtlas;
import swfdata.atlas.TextureTransform;

/**
* Для дебага и промежуточного состояния при формировании атласа пакером
*/
class BitmapTextureAtlas implements ITextureAtlas
{
    public var padding(get, set):Int;

    private var width:Float;
    private var height:Float;
    public var atlasData:BitmapData;
    
    public var texturesCount:Int = 0;
    public var subTextures:Map<Int, BitmapSubTexture> = new Map<Int, BitmapSubTexture>();
    
    private var _padding:Int = 0;
    
    public function new(width:Int, height:Int, padding:Int = 0)
    {
        this.height = height;
        this.width = width;
        _padding = padding;
        
        atlasData = new BitmapData(width, height, true, 0x0);
    }
	
	public function reset(bitmapData:BitmapData, padding:Int = 0)
	{
		atlasData = bitmapData;
		this.width = atlasData.width;
		this.height = atlasData.height;
		_padding = padding;
	}
    
    /**
	 * @inheritDoc
	 */
    public function getTexture(textureId:Int):ITexture
    {
        return subTextures[textureId];
    }
    
    /**
	 * @inheritDoc
	 */
    public function putTexture(texture:ITexture):Void
    {
        texturesCount++;
        subTextures[texture.id] = Lang.as2(texture, BitmapSubTexture);
    }
    
    public function createSubTexture(id:Int, region:Rectangle, scaleX:Float, scaleY:Float):ITexture
    {
        var subTexture:BitmapSubTexture = new BitmapSubTexture(id, region, new TextureTransform(scaleX, scaleY));
        putTexture(subTexture);
		
		return subTexture;
    }
    
    public function refrash():Void
    {
        subTextures = new Map<Int, BitmapSubTexture>();
        atlasData.fillRect(atlasData.rect, 0x0);
    }
    
    public function clear():Void
    {
        subTextures = null;
        atlasData.dispose();
        atlasData = null;
    }
    
    private function get_padding():Int
    {
        return _padding;
    }
    
    private function set_padding(value:Int):Int
    {
        _padding = value;
        return value;
    }
}