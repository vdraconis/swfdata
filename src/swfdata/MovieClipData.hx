package swfdata;

import swfdata.SpriteData;
import swfdata.Timeline;

class MovieClipData extends SpriteData implements ITimeline
{
    public var framesCount(get, never):Int;
    public var currentFrame(get, never):Int;
    public var isPlaying(get, never):Bool;
    public var currentFrameData(get, never):FrameData;

    public var timeline:Timeline;
    
    private var _currentFrameData:FrameData;
    
    public function new(characterId:Int = -1, framesCount:Int = 0)
    {
        super(characterId, DisplayObjectTypes.MOVIE_CLIP_TYPE, false);
        
        if (framesCount > 0) 
        {
            timeline = new Timeline(framesCount);
            _currentFrameData = timeline._currentFrameData;
        }
    }
    
    override public function destroy():Void
    {
        super.destroy();
        
        if (timeline != null) 
            timeline.destroy();
        
        timeline = null;
    }
    
    override public function updateMasks():Void
    {
        calculateMasks(timeline._currentFrameData);
    }
    
    public function getFrameByIndex(index:Int):FrameData
    {
        return timeline.frames[index];
    }
    
    public function nextFrame():Void
    {
        timeline.nextFrame();
        _currentFrameData = timeline._currentFrameData;
    }
    
    public function prevFrame():Void
    {
        timeline.prevFrame();
        _currentFrameData = timeline._currentFrameData;
    }
    
    private function get_framesCount():Int
    {
        return timeline.framesCount;
    }
    
    private function get_currentFrame():Int
    {
        return timeline._currentFrame;
    }
    
    public function addFrame(frameData:FrameData):Void
    {
        timeline.addFrame(frameData);
        _currentFrameData = timeline._currentFrameData;
    }
    
    public function play():Void
    {
        timeline.play();
    }
    
    public function gotoAndPlay(frame:Dynamic):Void
    {
        timeline.gotoAndPlay(frame);
        _currentFrameData = timeline._currentFrameData;
    }
    
    override public function gotoAndPlayAll(frameIndex:Int):Void
    {
        timeline.gotoAndPlayAll(frameIndex);
        _currentFrameData = timeline._currentFrameData;
    }
    
    public function stop():Void
    {
        timeline.stop();
    }
    
    public function gotoAndStop(frame:Dynamic):Void
    {
        timeline.gotoAndStop(frame);
        _currentFrameData = timeline._currentFrameData;
    }
    
    override public function gotoAndStopAll(frameIndex:Int):Void
    {
        timeline.gotoAndStopAll(frameIndex);
        _currentFrameData = timeline._currentFrameData;
    }
    
    private function get_isPlaying():Bool
    {
        return timeline.isPlaying;
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
    
    override private function get_displayObjects():Array<DisplayObjectData>
    {
        return _currentFrameData._displayObjects;
    }
    
    private function get_currentFrameData():FrameData
    {
        return _currentFrameData;
    }
    
    override public function addDisplayObject(displayObjectData:DisplayObjectData):Void
    {
        _currentFrameData.addDisplayObject(displayObjectData);
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
        
        var currentFrameData:FrameData = _currentFrameData;
        
        if (currentFrameData == null) 
            currentFrameData = timeline._currentFrameData;
        
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
        timeline.update();
        _currentFrameData = timeline._currentFrameData;
    }
    
    public function advanceFrame(delta:Int):Void
    {
        timeline.advanceFrame(delta);
        _currentFrameData = timeline._currentFrameData;
    }
    
    override private function setDataTo(objectCloned:DisplayObjectData):Void
    {
        super.setDataTo(objectCloned);
        
        var objestAsSpriteData:MovieClipData = try cast(objectCloned, MovieClipData) catch(e:Dynamic) null;
        objestAsSpriteData.timeline = timeline;
        _currentFrameData = timeline._currentFrameData;
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
}
