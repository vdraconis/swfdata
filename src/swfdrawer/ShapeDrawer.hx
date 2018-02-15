package swfdrawer;

import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import swfdata.atlas.ITextureAtlas;
import swfdata.DisplayObjectData;
import swfdata.ShapeData;
import swfdata.SwfdataInner;
import swfdrawer.GraphicsDrawer;
import swfdrawer.data.DrawingData;

class ShapeDrawer extends BitmapDrawer
{
    public var atlas(never, set):ITextureAtlas;
	
	private var draginMatrix:Matrix = new Matrix();
    
    public function new(atlas:ITextureAtlas, mousePoint:Point)
    {
        super(mousePoint);
        
        this.textureAtlas = cast atlas;
    }
    
    function set_atlas(value:ITextureAtlas):ITextureAtlas
    {
        textureAtlas = cast value;
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
        
        var drawableAsShape:ShapeData = cast(drawable, ShapeData);
        
        drawRectangle(drawableAsShape._shapeBounds, draginMatrix);
        
        cleanDrawStyle();
    }
}