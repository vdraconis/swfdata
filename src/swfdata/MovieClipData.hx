package swfdata;

import openfl.geom.Matrix;
import swfdata.SpriteData;
import swfdata.Timeline;

class MovieClipData extends SpriteData implements ITimeline
{
    public var framesCount(get, never):Int;
    public var currentFrame(get, never):Int;
    public var isPlaying(get, never):Bool;
    public var currentFrameData(get, never):FrameData;

    public var timeline:Timeline;
	public var timelineController:TimelineController;
    
    public function new(characterId:Int = -1, framesCount:Int = 0)
    {
        super(characterId, DisplayObjectTypes.MOVIE_CLIP_TYPE, false);
        
        if (framesCount > 0) 
        {
            timeline = new Timeline(framesCount);
			timelineController = new TimelineController(timeline);
        }
    }
	
	override public function get_numChildren():Int 
	{
		return currentFrameData.displayObjectsPlacedCount;
	}
	
	override private function get_displayObjects():Array<DisplayObjectData>
    {
        return currentFrameData._displayObjects;
    }
    
    function get_currentFrameData():FrameData
    {
        return timelineController.currentFrameData;
    }
	
	function get_framesCount():Int
    {
        return timelineController.framesCount;
    }
    
    function get_currentFrame():Int
    {
        return timelineController._currentFrame;
    }
    
    override public function updateMasks():Void
    {
        calculateMasks(timeline._currentFrameData);
    }
    
    public function getFrameByIndex(index:Int):FrameData
    {
        return timeline.getFrameByIndex(index);
    }
    
    public function nextFrame():Void
    {
        timelineController.nextFrame();
    }
    
    public function prevFrame():Void
    {
        timelineController.prevFrame();
    }
    
    public function addFrame(frameData:FrameData):Void
    {
        timeline.addFrame(frameData);
		timelineController.onAddFrame();
    }
    
    public function play():Void
    {
        timelineController.play();
    }
    
    public function gotoAndPlay(frame:Dynamic):Void
    {
        timelineController.gotoAndPlay(frame);
    }
    
    override public function gotoAndPlayAll(frameIndex:Int):Void
    {
        timelineController.gotoAndPlayAll(frameIndex);
    }
    
    public function stop():Void
    {
        timelineController.stop();
    }
    
    public function gotoAndStop(frame:Dynamic):Void
    {
        timelineController.gotoAndStop(frame);
    }
    
    override public function gotoAndStopAll(frameIndex:Int):Void
    {
        timelineController.gotoAndStopAll(frameIndex);
    }
    
    private function get_isPlaying():Bool
    {
        return timelineController.isPlaying;
    }
    
    //public function getFrameBounds(frameIndex:int = 0):Rectagon
    //{
    /*var frameData:FrameData = timeline.currentFrameData();
			
			childsBoundUnion.clear();
			
			for (var i:int = 0; i < frameData.displayObjects.length; i++)
			{
				var currentDisplayObject:DisplayObjectData = frameData.displayObjects[i];
				
				var currentChildBound:Rectagon;
				
				if (currentDisplayObject is ShapeData)
					currentChildBound = (currentDisplayObject as ShapeData).bounds//.clone();
				
				childsBoundUnion.union(currentChildBound);
			}
			
			return childsBoundUnion;*/
    
    //	return null;
    //}
    
    override public function addDisplayObject(displayObjectData:DisplayObjectData):Void
    {
        currentFrameData.addDisplayObject(displayObjectData);
    }
    
    override public function getObjectByDepth(depth:Int):DisplayObjectData
    {
        //var currentFrame:FrameData = timeline._currentFrameData;
        //return currentFrame.getObjectByDepth(depth);
        return null;
    }
    
    override public function getChildByName(name:String):DisplayObjectData
    {
        var currentDisplayObject:DisplayObjectData;
        var i:Int;
        
        var currentFrameData:FrameData = currentFrameData;
        
        var currentDisplayList:Array<DisplayObjectData> = currentFrameData.displayObjects;
        var frameChildsCount:Int = currentDisplayList.length;
        
        for (i in 0...frameChildsCount){
            currentDisplayObject = currentDisplayList[i];
            
            if (currentDisplayObject.name == name) 
                return currentDisplayObject;
        }
        
        for (i in 0...frameChildsCount){
            currentDisplayObject = currentDisplayList[i];
            
            if (Std.is(currentDisplayObject, IDisplayObjectContainer)) 
                return (try cast(currentDisplayObject, IDisplayObjectContainer) catch(e:Dynamic) null).getChildByName(name);
        }
        
        return null;
    }
    
    override public function update():Void
    {
        timelineController.update();
    }
    
    public function advanceFrame(delta:Int):Void
    {
        timelineController.advanceFrame(delta);
    }
    
    override private function setDataTo(objectCloned:DisplayObjectData):Void
    {
        super.setDataTo(objectCloned);
        
        var objestAsSpriteData:MovieClipData = cast(objectCloned, MovieClipData);
		objestAsSpriteData.transform = new Matrix();
        objestAsSpriteData.timeline = timeline;
		objestAsSpriteData.timelineController = new TimelineController(timeline);
    }

    inline public function inlineClone():DisplayObjectData
    {
        var objectCloned:MovieClipData = new MovieClipData(-1, 0);
        setDataTo(objectCloned);
        
        return objectCloned;
    }
    
    override public function clone():DisplayObjectData
    {
        var objectCloned:MovieClipData = new MovieClipData(-1, 0);
        setDataTo(objectCloned);
        
        return objectCloned;
    }
	
	override public function destroy():Void
    {
        super.destroy();
        
        if (timeline != null) 
            timeline.destroy();
        
        timeline = null;
    }
}