package swfdata;

import swfdata.IDisplayObjectContainer;



class FrameData extends DisplayObjectContainer
{
    public var frameIndex : Int;
    public var frameLabel : String;
    
    public function new(frameIndex : Int, frameLabel : String = null, numChildren : Int = 0)
    {
        super(numChildren);
        
        if (frameLabel != null) 
            this.frameLabel = frameLabel;
        
        this.frameIndex = frameIndex;
    }
    
    override public function destroy() : Void
    {
        super.destroy();
        
        frameLabel = null;
    }
    
    override public function clone() : IDisplayObjectContainer
    {
        var objectCloned : FrameData = new FrameData(frameIndex, frameLabel, numChildren);
        
        fillData(objectCloned);
        
        return objectCloned;
    }
    
    public function toString() : String
    {
        return "FrameData " + frameIndex + " frameObjects=" + displayObjects.length;
    }
    
    public function clear() : Void
    {
        frameLabel = null;
    }
}
