package swfdrawer;

import openfl.geom.Matrix;
import openfl.geom.Point;
import swfdata.DisplayObjectData;
import swfdata.ShapeData;
import swfdata.atlas.BitmapTextureAtlas;
import swfdata.atlas.ITextureAtlas;
import swfdrawer.data.DrawingData;
import utils.DisplayObjectUtils;

class ShapeDrawer extends BitmapDrawer
{
    public var atlas(never, set):ITextureAtlas;
	
	private var draginMatrix:Matrix = new Matrix();
    
    public function new(atlas:ITextureAtlas, mousePoint:Point)
    {
        super(mousePoint);
        
        this.textureAtlas = Lang.as2(atlas, BitmapTextureAtlas);
    }
    
    function set_atlas(value:ITextureAtlas):ITextureAtlas
    {
        textureAtlas = Lang.as2(value, BitmapTextureAtlas);
        return value;
    }
    
	@:access(swfdata)
    override public function draw(drawable:DisplayObjectData, drawingData:swfdrawer.data.DrawingData):Void
    {
        super.draw(drawable, drawingData);
        
        draginMatrix.identity();
        
        if (drawable.transform != null) 
            draginMatrix.concat(drawable.transform);
        
        draginMatrix.concat(drawingData.transform);
        
        var drawableAsShape:ShapeData = DisplayObjectUtils.asShape2(drawable, ShapeData);
        
        drawRectangle(drawableAsShape._shapeBounds, draginMatrix);
        
        cleanDrawStyle();
    }
}