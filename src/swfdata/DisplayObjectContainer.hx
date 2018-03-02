package swfdata;

import swfdata.DisplayObjectData;
import swfdata.IDisplayObjectContainer;
import swfdata.ITimelineContainer;
import utils.DisplayObjectUtils;

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
    
    public function destroy()
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
    
    public function addDisplayObject(displayObjectData:DisplayObjectData)
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
			
			var currentContainer = DisplayObjectUtils.asDisplayObjectContainer(currentDisplayObject);
            
            if (currentContainer != null) 
                return currentContainer.getChildByName(name);
        }
        
        return null;
    }
    
    //public function getObjectByCharacterId(characterId:int):DisplayObjectData
    //{
    //	return charactersMap? charactersMap[characterId]:null;
    //}
    
    public function gotoAndPlayAll(frameIndex:Int)
    {
        for (i in 0...displayObjectsPlacedCount)
		{
			var currentChild:DisplayObjectData = _displayObjects[i];
			var currentTimlineContainer = DisplayObjectUtils.asTimlineContainer(currentChild);
			
            if (currentTimlineContainer != null) 
                currentTimlineContainer.gotoAndPlayAll(frameIndex);
        }
    }
    
    public function gotoAndStopAll(frameIndex:Int)
    {
        for (i in 0...displayObjectsPlacedCount)
		{
            var currentChild:DisplayObjectData = _displayObjects[i];
			var currentTimlineContainer = DisplayObjectUtils.asTimlineContainer(currentChild);
			
            if (currentTimlineContainer != null) 
                currentTimlineContainer.gotoAndStopAll(frameIndex);
        }
    }
    
    public function update()
    {
        for (i in 0...displayObjectsPlacedCount)
		{
			var currentChild:DisplayObjectData = _displayObjects[i];
			var currentChildAsUpdatable = DisplayObjectUtils.asUpdatable(currentChild);
			
			if(currentChildAsUpdatable != null)
				untyped currentChild.update();
        }
    }
    
    private function fillData(obj:DisplayObjectContainer)
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