package swfdrawer;

import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import swfdata.DisplayObjectData;
import swfdata.IDisplayObjectContainer;
import swfdata.MovieClipData;
import swfdrawer.data.DrawerMatrixPool;
import swfdrawer.data.DrawingData;
import swfdrawer.IDrawer;

class MovieClipDrawer implements IDrawer
{
    private var matricesPool:DrawerMatrixPool = DrawerMatrixPool.instance;
    
    private var displayListDrawer:IDrawer;
    
    public function new(displayListDrawer:IDrawer)
    {
        this.displayListDrawer = displayListDrawer;
    }
    
    public function draw(drawable:DisplayObjectData, drawingData:DrawingData):Void
    {
        var movieClipDrawable:MovieClipData = cast(drawable, MovieClipData);
        
        var calculateMyFrame:Int = 0;
        
        var frameData:IDisplayObjectContainer = movieClipDrawable.currentFrameData;
        
        var drawableTransformClone:Matrix = matricesPool.getMatrix();
        
        var drawableTrasnform:Matrix = drawable.transform;
        drawableTransformClone.setTo(drawableTrasnform.a, drawableTrasnform.b, drawableTrasnform.c, drawableTrasnform.d, drawableTrasnform.tx, drawableTrasnform.ty);
        drawableTransformClone.concat(drawingData.transform);
        
        var objectsLenght:Int = frameData.displayObjects.length;
        
        drawingData.setFromDisplayObject(drawable);
        
        //TODO: Дублирвоания того же кода что в спрайт дравер, нужно как то их сшить воедино
        var currentMaskState:Bool = drawingData.isMask;
        var currentMaskedState:Bool = drawingData.isMasked;
        
        for (i in 0...objectsLenght) 
		{
            var childDisplayObject:DisplayObjectData = frameData.displayObjects[i];
            
            drawingData.transform = drawableTransformClone;
            
            displayListDrawer.draw(childDisplayObject, drawingData);
            
            drawingData.isMask = currentMaskState;
            drawingData.isMasked = currentMaskedState;
        }
        
        matricesPool.disposeMatrix(drawableTransformClone);
    }
}