package swfdata;

import IUpdatable;
import swfdata.ITimelineContainer;

interface IDisplayObjectContainer extends ITimelineContainer extends IUpdatable
{
    var numChildren(get, never):Int;    
    var displayObjects(get, never):Array<DisplayObjectData>;
    
    function addDisplayObject(displayObjectData:DisplayObjectData):Void;
	
	function removeDisplayObject(displayObjectData:DisplayObjectData):Void;
    
    function getObjectByDepth(depth:Int):DisplayObjectData;
    
    //function getObjectByCharacterId(characterId:int):DisplayObjectData;
    
    function getChildByName(name:String):DisplayObjectData;
}