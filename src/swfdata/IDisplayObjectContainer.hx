package swfdata;

import swfdata.ITimelineContainer;
import IUpdatable;

interface IDisplayObjectContainer extends ITimelineContainer extends IUpdatable
{
    
    var numChildren(get, never) : Int;    
    var displayObjects(get, never) : Array<DisplayObjectData>;

    
    function addDisplayObject(displayObjectData : DisplayObjectData) : Void;
    
    function getObjectByDepth(depth : Int) : DisplayObjectData;
    
    //function getObjectByCharacterId(characterId:int):DisplayObjectData;
    
    function getChildByName(name : String) : DisplayObjectData;
}
