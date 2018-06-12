package swfdrawer;

import swfdata.ColorData;
import swfdata.DisplayObjectData;
import swfdrawer.data.DrawingData;
import swfdrawer.data.PooledMatrix;
import utils.DisplayObjectUtils;

class DisplayObjectContainerDrawer implements IDrawer
{
	private var displayListDrawer:IDrawer;
	
	public function new(displayListDrawer:IDrawer)
	{
		this.displayListDrawer = displayListDrawer;
	}
	
	
	public function draw(drawable:DisplayObjectData, drawingData:DrawingData)
	{
		var displayObjectContainer = DisplayObjectUtils.asDisplayObjectContainer2(drawable);
		
		var concentratedTransform = PooledMatrix.getWithAndConcat(drawable.transform, drawingData.transform);
		var concentratedMaskState = drawingData.isMask || drawable.isMask;
		//var concentratedMaskedState = drawingData.isMasked || (drawable.mask != null); TODO: mask drawing not worked
		var concentratedBlendMode = drawable.blendMode;
		var concentratedColorData = drawable.colorData != null? ColorData.getWithAndConcat(drawable.colorData, drawingData.colorData):drawingData.colorData;
		
		var displayObjects:Array<DisplayObjectData> = displayObjectContainer.displayObjects;
		var childsCount = displayObjectContainer.numChildren;
		
		for (i in 0...childsCount)
		{
			var childDisplayObject:DisplayObjectData = displayObjects[i];
			
			drawingData.transform = concentratedTransform;
			drawingData.colorData = concentratedColorData;
			drawingData.isMask = concentratedMaskState;
			//drawingData.isMasked = concentratedMaskedState;
			
			var isBlendModeChange:Bool = childDisplayObject.blendMode != 0 && concentratedBlendMode == 0;
			
			// TODO странная ситуация с затиранием и блендингами родителей.
			if (isBlendModeChange)
				drawingData.blendMode = childDisplayObject.blendMode;
			
			displayListDrawer.draw(childDisplayObject, drawingData);
				
			//возвращаем дате родительский блендинг
			if(isBlendModeChange)
				drawingData.blendMode = concentratedBlendMode;
		}
		
		concentratedTransform.free();
		concentratedColorData.free();
		
		//drawingData.transform = null;
		//drawingData.colorData = null;
	}
}