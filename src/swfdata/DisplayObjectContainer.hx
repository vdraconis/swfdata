package swfdata;

import swfdata.DisplayObjectData;
import swfdata.IDisplayObjectContainer;
import swfdata.ITimelineContainer;

class DisplayObjectContainer implements IDisplayObjectContainer
{
    public var numChildren(get, never):Int;
    public var displayObjects(get, never):Array<DisplayObjectData>;
	
    @:allow(swfdata) var _displayObjects:Array<DisplayObjectData>;
    var displayObjectsCount:Int = 0;
    @:allow(swfdata) var displayObjectsPlacedCount:Int = 0;
    
    //public var depthMap:Object;
    //public var charactersMap:Object = { };
    
    var depthAndCharactersMapInitialize:Bool = false;
    
    public function new(displayObjectsCount:Int = 0)
    {
        this.displayObjectsCount = displayObjectsCount;
        _displayObjects = new Array<DisplayObjectData>();
    }
    
    private function get_numChildren():Int
    {
        return displayObjectsPlacedCount;
    }
    
    public function destroy():Void
    {
        //depthMap = null;
        
        if (_displayObjects != null) 
        {
            for (i in 0...displayObjectsPlacedCount)
			{
                if (_displayObjects[i] != null) 
                    _displayObjects[i].destroy();
            }
            
            _displayObjects = null;
        }
    }
    
    public function addDisplayObject(displayObjectData:DisplayObjectData):Void
    {
        //if (!depthAndCharactersMapInitialize)
        //{
        //depthMap = {};
        //charactersMap = {};
        //depthAndCharactersMapInitialize = true;
        //}
        
        _displayObjects[displayObjectsPlacedCount++] = displayObjectData;
    }
    
    public function getObjectByDepth(depth:Int):DisplayObjectData
    {
        return null;
    }
    
    public function getChildByName(name:String):DisplayObjectData
    {
        var currentDisplayObject:DisplayObjectData;
        var i:Int;
        
        var currentDisplayList:Array<DisplayObjectData> = _displayObjects;
        var childsCount:Int = currentDisplayList.length;
        
        for (i in 0...childsCount){
            currentDisplayObject = currentDisplayList[i];
            
            if (currentDisplayObject.name == name) 
                return currentDisplayObject;
        }
        
        for (i in 0...childsCount){
            currentDisplayObject = currentDisplayList[i];
            
            if (Std.is(currentDisplayObject, IDisplayObjectContainer)) 
                return cast(currentDisplayObject, IDisplayObjectContainer).getChildByName(name);
        }
        
        return null;
    }
    
    //public function getObjectByCharacterId(characterId:int):DisplayObjectData
    //{
    //	return charactersMap? charactersMap[characterId]:null;
    //}
    
    public function gotoAndPlayAll(frameIndex:Int):Void
    {
        for (i in 0...displayObjectsPlacedCount	)
		{
			var currentChild:DisplayObjectData = _displayObjects[i];
			
            if (Std.is(currentChild, ITimelineContainer)) 
            {
                cast(_displayObjects[i], ITimelineContainer).gotoAndPlayAll(frameIndex);
            }
        }
    }
    
    public function gotoAndStopAll(frameIndex:Int):Void
    {
        for (i in 0...displayObjectsPlacedCount)
		{
            var currentDisplayData:DisplayObjectData = _displayObjects[i];
            if (Std.is(currentDisplayData, ITimelineContainer)) 
                cast(currentDisplayData, ITimelineContainer).gotoAndStopAll(frameIndex);
        }
    }
    
    public function update():Void
    {
        for (i in 0...displayObjectsPlacedCount)
		{
			var currentChild:DisplayObjectData = _displayObjects[i];
			
            if (Std.is(currentChild, IUpdatable)) 
            {
				cast (currentChild, IUpdatable).update();
            }
        }
    }
    
    private function fillData(obj:DisplayObjectContainer):Void
    {
        var objDisplayObjects:Array<DisplayObjectData> = obj.displayObjects;
		
        for (i in 0...displayObjectsPlacedCount)
		{
            //obj.displayObjects.push(_displayObjects[i].clone());
            objDisplayObjects[i] = _displayObjects[i];
        }
        
        obj.displayObjectsCount = displayObjectsPlacedCount;
		obj.displayObjectsPlacedCount = displayObjectsPlacedCount;
    }
    
    public function clone():IDisplayObjectContainer
    {
        var objectCloned:DisplayObjectContainer = new DisplayObjectContainer(displayObjectsCount);
        
        fillData(objectCloned);
        
        return objectCloned;
    }
    
    private function get_displayObjects():Array<DisplayObjectData>
    {
        return _displayObjects;
    }
}