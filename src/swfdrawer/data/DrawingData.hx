package swfdrawer.data;

import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import swfdata.ColorData;
import swfdata.ColorMatrix;
import swfdata.DisplayObjectData;

@:access(swfdata)
class DrawingData
{
    private var isClear:Bool = true;
    
    public var bound:Rectangle = null;
    
    public var maskId:Int = -1;
    public var isMask:Bool = false;
    public var isMasked:Bool = false;
    
    public var transform:Matrix = null;
	public var blendMode:Int = 0;
	
	public var hitTestResult:Bool = false;
	public var hitTarget:DisplayObjectData;
    
    //public var isApplyColorTrasnform:Bool = false;
    //public var colorTransform:ColorMatrix = new ColorMatrix(null);
    
    public var colorData:ColorData = new ColorData();
    
    public function new()
    {
		
    }
    
    /*public function addColorTransform(colorTransformToApply:ColorMatrix):Void
    {
        isApplyColorTrasnform = true;
        //this.colorTransform.reset();
        this.colorTransform.premultiply(colorTransformToApply.matrix);
    }*/
    
    public function clear():Void
    {
        //if (isClear == false)
        //	return;
        
        //isClear = true;
        colorData.clear();
        
        //isApplyColorTrasnform = false;
        //colorTransform.reset();// [0] = -1234;
        
        maskId = -1;
        isMask = false;
        isMasked = false;
        transform = null;
        bound = null;
    }
    
    public function mulColorData(colorData:ColorData):Void
    {
        //isClear = false;
        this.colorData.concat(colorData);
    }
    
    inline public function setFromDisplayObject(drawable:DisplayObjectData):Void
    {
        //isClear = false;
        
        isMask = isMask || drawable.isMask;
        isMasked = isMasked || (drawable.mask != null);
		
		//TODO: в SpriteDrawer и MovieClipDrawer нужно сохранять состояние колора для каждого из потдеревьев потомков
		if(drawable.colorData != null)
			colorData.preMultiply(drawable.colorData);
    }
}