package swfdata;

import IUpdatable;
import swfdata.ITimelineContainer;

interface IDisplayObjectContainer extends ITimelineContainer extends IUpdatable
{
    var numChildren(get, never):Int;    
    var displayObjects(get, never):Array<DisplayObjectData>;
    
    function addChild(displayObjectData:DisplayObjectData):Void;
	
	function removeChild(displayObjectData:DisplayObjectData):Void;
    
    function getObjectByDepth(depth:Int):DisplayObjectData;
    
    //function getObjectByCharacterId(characterId:int):DisplayObjectData;
    
    function getChildByName(name:String):DisplayObjectData;
}