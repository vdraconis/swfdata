package gl.drawer;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import swfdata.atlas.ITextureAtlas;
import swfdata.DisplayObjectData;
import swfdata.ShapeData;
import swfdata.SwfdataInner;
import swfdrawer.data.DrawingData;
import gl.drawer.GLDrawer;

class GLShapeDrawer extends GLDrawer
{
    public var atlas(never, set):ITextureAtlas;

    private var myMatrix:Matrix = new Matrix();
    
    public function new(atlas:ITextureAtlas, mousePoint:Point)
    {
        super(mousePoint);
        
        this.textureAtlas = atlas;
    }
    
    private function set_atlas(value:ITextureAtlas):ITextureAtlas
    {
        textureAtlas = value;
        return value;
    }
    
	@:access(swfdata)
    override public function draw(drawable:DisplayObjectData, drawingData:swfdrawer.data.DrawingData):Void
    {
        super.draw(drawable, drawingData);
        
        myMatrix.identity();
        
        if (drawable.transform != null) 
        {
            myMatrix.concat(drawable.transform);
        }
        
        myMatrix.concat(drawingData.transform);
        
        var drawableAsShape:ShapeData = cast drawable;
        
        drawRectangle(drawableAsShape._shapeBounds, myMatrix);
        
        cleanDrawStyle();
    }
}

