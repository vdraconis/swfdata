package swfdata.datatags;

class SwfPackerTagRemoveObject extends SwfPackerTag
{
    public var characterId:Int;
    public var depth:Int;
    
    public function new(characterId:Int = 0, depth:Int = 0)
    {
        super();
        this.depth = depth;
        this.characterId = characterId;
        
        type = 5;
    }
    
    override public function clear():Void
    {
        
    }
    
    public function isEquals(tagRemoveObject:SwfPackerTagRemoveObject):Bool
    {
        return tagRemoveObject.characterId == characterId && tagRemoveObject.depth == depth;
    }
    
    public function toString():String
    {
        return "[SwfPackerTagRemoveObject characterId=" + characterId + " depth=" + depth + "]";
    }
}