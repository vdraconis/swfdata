package swfdrawer;

import openfl.geom.Matrix;
import swfdata.ColorData;
import swfdata.DisplayObjectData;
import swfdata.IDisplayObjectContainer;
import swfdrawer.data.DrawingData;
import swfdrawer.data.PooledMatrix;

class DisplayObjectContainerDrawer implements IDrawer
{
    private var displayListDrawer:IDrawer;
    
    public function new(displayListDrawer:IDrawer)
    {
        this.displayListDrawer = displayListDrawer;
    }
    
    public function draw(drawable:DisplayObjectData, drawingData:DrawingData)
    {
        var displayObjectContainer:IDisplayObjectContainer = cast(drawable, IDisplayObjectContainer);
        
        var drawableTrasnform:Matrix = drawable.transform;
        
        var drawableTransformClone:PooledMatrix = PooledMatrix.get(drawableTrasnform.a, drawableTrasnform.b, drawableTrasnform.c, drawableTrasnform.d, drawableTrasnform.tx, drawableTrasnform.ty);
        drawableTransformClone.concat(drawingData.transform);
        
        var objectsLenght:Int = displayObjectContainer.numChildren;
        
        drawingData.setFromDisplayObject(drawable);
        drawingData.blendMode = drawable.blendMode;
        
        var drawingColorData:ColorData = drawingData.colorData;
        var colorDataBuffer:ColorData = ColorData.getWith(drawingColorData);
        
        var currentMaskState:Bool = drawingData.isMask;
        var currentMaskedState:Bool = drawingData.isMasked;
        
        var displayObjects:Array<DisplayObjectData> = displayObjectContainer.displayObjects;
        
        for (i in 0...objectsLenght)
        {
            var childDisplayObject:DisplayObjectData = displayObjects[i];
            
            drawingData.transform = drawableTransformClone;
            
            // TODO странная ситуация с затиранием и блендингами родителей.
            if (childDisplayObject.blendMode != 0 && !(drawable.blendMode != 0))
            {
                drawingData.blendMode = childDisplayObject.blendMode;
            }
            
            displayListDrawer.draw(childDisplayObject, drawingData);
            
            drawingData.isMask = currentMaskState;
            drawingData.isMasked = currentMaskedState;
            
            drawingColorData.setFromData(colorDataBuffer);
            // возвращаем дате родительский блендинг
            drawingData.blendMode = drawable.blendMode;
        }
        //drawingData.blendMode = drawable.blendMode;
        
        drawingColorData.setFromData(colorDataBuffer);
        drawableTransformClone.dispose();
        colorDataBuffer.dispose();
    }
}

