package swfdata;

import swfdata.DisplayObjectData;
import utils.DisplayObjectUtils;

using swfdata.SpriteData;

class SpriteData extends DisplayObjectData implements IDisplayObjectContainer
{
	public var isMouseDown:Bool = false;
	public var isMouseOver:Bool = false;
	
	public var mouseX:Float = 0;
	public var mouseY:Float = 0;
	
    public var numChildren(get, never):Int;
    public var displayObjects(get, never):Array<DisplayObjectData>;

    var displayContainer:DisplayObjectContainer;
    
    public function new(characterId:Int = -1, displayObjectType:Int = DisplayObjectTypes.SPRITE_TYPE, isCreateContainer:Bool = true, childsCount:Int = 0)
    {
        super(characterId, displayObjectType);
        
        if (isCreateContainer) 
            displayContainer = new DisplayObjectContainer(childsCount);
    }
    
	public function onMouseOver():Void
	{
		isMouseOver = true;
	}
	
	public function onMouseOut():Void
	{
		isMouseOver = false;
	}
	
	public function onMouseUp():Void
	{
		isMouseDown = false;
	}
	
	public function onMouseDown():Void
	{
		isMouseDown = true;
	}
	
    function get_numChildren():Int
    {
        return displayContainer.numChildren;
    }
    
    override public function destroy():Void
    {
        super.destroy();
        
        if (displayContainer != null) 
        {
            displayContainer.destroy();
            displayContainer = null;
        }
    }
    
    public function update():Void
    {
        displayContainer.update();
    }
    
    public function updateMasks():Void
    {
        
        calculateMasks(this);
    }
    
    function calculateMasks(displayObjectContainer:IDisplayObjectContainer):Void
    {
        var currentMask:DisplayObjectData = null;
        
        var displayObjectsCount:Int = displayObjectContainer.displayObjects.length;
		
        for (i in 0...displayObjectsCount)
		{
            var currentDisplayObject:DisplayObjectData = displayObjectContainer.displayObjects[i];
            
            if (currentDisplayObject == null) 
				continue;
            
            if (currentDisplayObject.isMask) 
                currentMask = currentDisplayObject;
            else if (currentMask != null && currentDisplayObject.depth <= currentMask.clipDepth) 
                currentDisplayObject.mask = currentMask;
        }
    }
    
    inline public static function setDataFrom(to:SpriteData, from:SpriteData):Void
    {
        DisplayObjectData.setDataFrom(to, from);
        
        if (from.displayContainer != null) 
        {
            var objestAsSpriteData:SpriteData = to;
            objestAsSpriteData.displayContainer = from.displayContainer;  //.clone() as DisplayObjectContainer;  ;
        }
    }
	
	override public function softClone():DisplayObjectData 
	{
		var objectCloned:SpriteData = new SpriteData(-1, DisplayObjectTypes.SPRITE_TYPE, false);
        objectCloned.setDataFrom(this);
		
        return objectCloned;
	}
    
    override public function clone():DisplayObjectData
    {
        return softClone();
    }
    
    /* INTERFACE swfdata.IDisplayObjectContainer */
    
    public function addDisplayObject(displayObjectData:DisplayObjectData):Void
    {
        displayContainer.addDisplayObject(displayObjectData);
    }
    
    //public function getObjectByCharacterId(characterId:int):DisplayObjectData
    //{
    //	return displayContainer.getObjectByCharacterId(characterId);
    //}
    
    public function gotoAndPlayAll(frameIndex:Int):Void
    {
        displayContainer.gotoAndPlayAll(frameIndex);
    }
    
    public function gotoAndStopAll(frameIndex:Int):Void
    {
        displayContainer.gotoAndStopAll(frameIndex);
    }
    
    public function getObjectByDepth(depth:Int):DisplayObjectData
    {
        return displayContainer.getObjectByDepth(depth);
    }
    
    public function getChildByName(name:String):DisplayObjectData
    {
        return displayContainer.getChildByName(name);
    }
    
    private function get_displayObjects():Array<DisplayObjectData>
    {
        return displayContainer._displayObjects;
    }
}
