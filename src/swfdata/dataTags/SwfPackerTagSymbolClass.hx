package swfdata.datatags;

class SwfPackerTagSymbolClass extends SwfPackerTag
{
    public var characterIdList:Array<Int>;
    public var linkageList:Array<String>;
    
    public var length:Int;
    
    public function new(length:Int = 0)
    {
        super();
        
        type = 76;  //from swf tags specification  
        
        this.length = length;
        
        if (length != 0) 
        {
            initializeContent();
        }
    }
    
    public function initializeContent(fixedSize:Bool = true):Void
    {
        characterIdList = new Array<Int>();
        linkageList = new Array<String>();
    }
    
    override public function clear():Void
    {
        characterIdList = null;
        linkageList = null;
    }
}