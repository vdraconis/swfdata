package swfdata.datatags;

import swfdata.FrameData;

class SwfPackerTagDefineSprite extends SwfPackerTag
{
    public var characterId:Int;
    public var frameCount:Int;
    
    public var tags:Array<SwfPackerTag>;
    public var frames:Array<FrameData>;
    
    public function new()
    {
        super();
        type = 39;
    }
    
    override public function clear():Void
    {
        var i:Int;
        for (i in 0...frames.length){
            frames[i].clear();
        }
        
        for (i in 0...tags.length){
            tags[i].clear();
        }
        
        frames = null;
        tags = null;
    }
}