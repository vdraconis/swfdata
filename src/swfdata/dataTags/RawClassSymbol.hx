package swfdata.datatags;

class RawClassSymbol
{
    public var characterId:Int;
    public var linkage:String;
    
    public function new(characterId:Int = 0, linkage:String = null)
    {
        this.linkage = linkage;
        this.characterId = characterId;
    }
    
    public function clear():Void
    {
        linkage = null;
    }
    
    public function toString():String
    {
        return "[RawClassSymbol characterId=" + characterId + " linkage=" + linkage + "]";
    }
}