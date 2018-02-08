package swfdrawer.data;

class DisplayListDrawData
{
    public var frameIndex:Int = 0;
    public var isCleanBefore:Bool = false;
    public var isFill:Bool = true;
    public var isStroke:Bool = true;
    public var isMask:Bool = false;
    public var isMasked:Bool = false;
    public var maskId:Int = -1;
    
    public function new()
    {
        
    }
    
    public function clear():Void
    {
        frameIndex = 0;
        isCleanBefore = false;
        isFill = true;
        isStroke = true;
        isMask = false;
        isMask = false;
        maskId = -1;
    }
}