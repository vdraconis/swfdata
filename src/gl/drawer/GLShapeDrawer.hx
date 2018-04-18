package gl.drawer;

import gl.drawer.GLDrawer;
import openfl.geom.Matrix;
import openfl.geom.Point;
import swfdata.DisplayObjectData;
import swfdata.ShapeData;
import swfdata.atlas.TextureStorage;
import swfdrawer.data.DrawingData;
import utils.DisplayObjectUtils;

class GLShapeDrawer extends GLDrawer
{
    var _drawMatrix:Matrix = new Matrix();
    
    public function new(textureStorage:TextureStorage, mousePoint:Point)
    {
        super(mousePoint);
        
        this.textureStorage = textureStorage;
    }
    
	@:access(swfdata)
    override public function draw(drawable:DisplayObjectData, drawingData:DrawingData):Void
    {
        super.draw(drawable, drawingData);
        
        _drawMatrix.identity();
        
        if (drawable.transform != null) 
            _drawMatrix.concat(drawable.transform);
        
        _drawMatrix.concat(drawingData.transform);
        
        var drawableAsShape:ShapeData = DisplayObjectUtils.asShape2(drawable);
        
        drawRectangle(drawableAsShape._shapeBounds, _drawMatrix);
        
        //cleanDrawStyle();
    }
}

