package swfparser;


import swfdata.DisplayObjectContainer;
import swfdata.DisplayObjectData;
import swfdata.DisplayObjectTypes;
import swfdata.MovieClipData;
import swfdata.SpriteData;
import swfdata.SwfdataInner;



class DisplayObjectContext
{
    public var currentDisplayObjectAsMovieClip:MovieClipData;
    public var currentDisplayObject:SpriteData;
    public var currentContainer:DisplayObjectContainer;
    public var currentDisplayList:Array<DisplayObjectData>;
    
    public function new()
    {
        
        
    }
    
	@:access(swfdata)
	inline public function setCurrentDisplayObject(displayObject:SpriteData):Void
    {
        currentDisplayObjectAsMovieClip = null;
        currentContainer = null;
        currentDisplayList = null;
        
        currentDisplayObject = displayObject;
        
        if (currentDisplayObject == null) 
            return;
        
        if (currentDisplayObject.displayObjectType == DisplayObjectTypes.SPRITE_TYPE) 
        {
            currentContainer = currentDisplayObject.displayContainer;
            currentDisplayList = currentContainer._displayObjects;
        }
        else 
        {
            currentDisplayObjectAsMovieClip = try cast(currentDisplayObject, MovieClipData) catch(e:Dynamic) null;
            updateFrame();
        }
    }
    
	@:access(swfdata)
	inline public function updateFrame():Void
    {
        currentContainer = currentDisplayObjectAsMovieClip.currentFrameData;
        currentDisplayList = currentContainer._displayObjects;
    }
    
	inline public function nextFrame():Void
    {
        if (currentDisplayObjectAsMovieClip == null) 
            return;
        
        currentDisplayObjectAsMovieClip.nextFrame();
        updateFrame();
    }
    
    public function clear():Void
    {
        if (currentDisplayObject != null) 
            currentDisplayObject.destroy();
        
        currentDisplayObjectAsMovieClip = null;
        currentDisplayObject = null;
        currentContainer = null;
        currentDisplayList = null;
    }
}