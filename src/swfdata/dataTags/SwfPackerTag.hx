package swfdata.datatags;

import openfl.errors.Error;

class SwfPackerTag
{
    public var type:Int;
    
    public function new()
    {
        
    }
    
    public function clear():Void
    {
        throw new Error("no default method implementation");
    }
	
	public function toString():String 
	{
		return '[${Type.getClass(this)} type=$type]';
	}
}