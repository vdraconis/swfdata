package swfdata;

class LayerData
{
    public var depth:Int;
    public var frameCount:Int;
    public var isMask:Bool;
    public var clipDepth:Int;
    public var isMasked:Bool;
    public var mask:LayerData;
    public var maskedLayers:Array<LayerData> = new Array<LayerData>();
    
    public function new(depth:Int, frameCount:Int)
    {
        this.frameCount = frameCount;
        this.depth = depth;
    }
    
    public function setClipAndDepthData(hasClipDepth:Bool, clipDepth:Int):Void
    {
        isMask = hasClipDepth;
        this.clipDepth = clipDepth;
    }
    
    public function addFrame(frameData:FrameData):Void
    {
        
    }
    
    public function maskLayer(maskedLayer:LayerData):Void
    {
        maskedLayers.push(mask);
        maskedLayer.maskBy(this);
    }
    
    private function maskBy(mask:LayerData):Void
    {
        isMasked = true;
        this.mask = mask;
    }
    
    public function toString():String
    {
        return "[LayerData depth=" + depth + " frameCount=" + frameCount + " isMask=" + isMask + " mask=" + mask + "]";
    }
}