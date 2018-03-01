package gl.drawer;

import gl.drawer.GLDrawer;
import openfl.geom.Matrix;
import openfl.geom.Point;
import swfdata.DisplayObjectData;
import swfdata.ShapeData;
import swfdata.atlas.ITextureAtlas;
import swfdata.atlas.TextureStorage;
import swfdrawer.data.DrawingData;

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
        {
            GeomMath.concatMatrices(_drawMatrix, drawable.transform, _drawMatrix);
        }
        
        GeomMath.concatMatrices(_drawMatrix, drawingData.transform, _drawMatrix);
        
        var drawableAsShape:ShapeData = cast(drawable, ShapeData);
        
        drawRectangle(drawableAsShape._shapeBounds, _drawMatrix);
        
        cleanDrawStyle();
    }
}

