package swfdrawer;

import openfl.geom.Matrix;
import swfdata.DisplayObjectData;
import swfdata.IDisplayObjectContainer;
import swfdata.SpriteData;
import swfdrawer.IDrawer;
import swfdrawer.data.DrawerMatrixPool;
import swfdrawer.data.DrawingData;

class SpriteDrawer implements IDrawer
{
    private var matricesPool:DrawerMatrixPool = DrawerMatrixPool.instance;
    
    private var displayListDrawer:IDrawer;
    
    public function new(displayListDrawer:IDrawer)
    {
        this.displayListDrawer = displayListDrawer;
    }
    
    public function draw(drawable:DisplayObjectData, drawingData:DrawingData):Void
    {
        var spriteDrawable:SpriteData = cast(drawable, SpriteData);
        
        var frameData:IDisplayObjectContainer = spriteDrawable;
        
        var drawableTransformClone:Matrix = matricesPool.getMatrix();
        
        var drawableTrasnform:Matrix = drawable.transform;
        
        drawableTransformClone.setTo(drawableTrasnform.a, drawableTrasnform.b, drawableTrasnform.c, drawableTrasnform.d, drawableTrasnform.tx, drawableTrasnform.ty);
        drawableTransformClone.concat(drawingData.transform);
        
        var objectsLenght:Int = frameData.displayObjects.length;
        
        drawingData.setFromDisplayObject(drawable);
        
        /*
				//trace("-------------------------------------", drawingData.isApplyColorTrasnform);
				if (drawable.colorTransform)
				{
					//trace('was', drawingData.colorTransform.matrix);
					drawingData.addColorTransform(drawable.colorTransform);
					//trace("DRW", drawable.colorTransform.matrix, "|",drawable.name);
					//trace('get', drawingData.colorTransform.matrix);
				}
				else
				{
					drawingData.isApplyColorTrasnform = false;
				}
				//trace("-------------------------------------");
				
				var isApplyColorTransform:Boolean  = drawingData.isApplyColorTrasnform;
				
				var matrix:Vector.<Number>
				//if(isApplyColorTransform)
					matrix = drawingData.colorTransform.matrix.slice();
			*/  //Disabled color transofrm;  
        
        var currentMaskState:Bool = drawingData.isMask;
        var currentMaskedState:Bool = drawingData.isMasked;
        
        for (i in 0...objectsLenght)
		{
            var childDisplayObject:DisplayObjectData = frameData.displayObjects[i];
            
            //if (isApplyColorTransform)
            //{
            //	drawingData.colorTransform.matrix = matrix.slice();
            //}
            
            drawingData.transform = drawableTransformClone;
            
            displayListDrawer.draw(childDisplayObject, drawingData);
            
            drawingData.isMask = currentMaskState;
            drawingData.isMasked = currentMaskedState;
        }
        
        matricesPool.disposeMatrix(drawableTransformClone);
    }
}