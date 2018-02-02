package swfdata;

import IUpdatable;
import openfl.Vector;

class Timeline implements ITimeline implements ITimelineContainer implements IUpdatable
{
    public var framesCount(get, never):Int;
    public var currentFrame(get, never):Int;
    public var isPlaying(get, never):Bool;

    private var _isPlaying:Bool = true;
    public var frames:Vector<FrameData>;
    
    public var labelsCount:Int = 0;
    public var lablesMap:Map<String, Int> = new Map<String, Int>();
    public var labelsSize:Map<String, Int> = new Map<String, Int>();
    
	@:allow(swfdata)
    private var _currentFrame:Int = 0;
	
	@:allow(swfdata)
    private var _currentFrameData:FrameData;
    
    public var _framesCount:Int = 0;
    
    private var currentLable:String;
    
    public function new(framesCount:Int)
    {
        _framesCount = framesCount;
        frames = new Vector<FrameData>(_framesCount, true);
        
        _currentFrameData = frames[_currentFrame];
    }
    
    public function destroy():Void
    {
        lablesMap = null;
        labelsSize = null;
        currentLable = null;
        
        if (frames != null) 
        {
            var framesCount:Int = frames.length;
            for (i in 0...framesCount){
                frames[i].destroy();
            }
            
            frames = null;
        }
    }
    
    public function getLabelSize(label:String):Int
    {
        return labelsSize[label];
    }
    
    public function hasFrame(label:String):Bool
    {
        return lablesMap[label] != null;
    }
    
    public function setLabel(labelKey:String, startFrame:Int, framesCount:Int):Void
    {
        if (lablesMap[labelKey] != null) 
            return;
        
        frames[startFrame].frameLabel = labelKey;
        
        labelsSize[labelKey] = framesCount;
        lablesMap[labelKey] = startFrame;
        labelsCount++;
    }
    
    public function addFrame(frameData:FrameData):Void
    {
        if (frameData.frameLabel != null) 
        {
            currentLable = frameData.frameLabel;
            
			labelsSize[currentLable] = 0;
			
            lablesMap[frameData.frameLabel] = frameData.frameIndex;
            labelsCount++;
        }
        
        if (currentLable != null) 
            labelsSize[currentLable] = labelsSize[currentLable] + 1;
        
        frames[frameData.frameIndex] = frameData;
        
        if (_currentFrameData == null) 
            _currentFrameData = frameData;
    }
    
    public function gotoAndPlayAll(frameIndex:Int):Void
    {
        gotoAndPlay(frameIndex);
        
        for (i in 0..._framesCount){
            frames[i].gotoAndPlayAll(frameIndex);
        }
    }
    
    public function gotoAndStopAll(frameIndex:Int):Void
    {
        gotoAndStop(frameIndex);
        
        for (i in 0..._framesCount){
            frames[i].gotoAndStopAll(frameIndex);
        }
    }
    
    public function play():Void
    {
        this._isPlaying = true;
    }
    
    public function gotoAndPlay(frame:Dynamic):Void
    {
        
        play();
        setFrameByObject(frame);
    }
    
    public function stop():Void
    {
        this._isPlaying = false;
    }
    
    public function gotoAndStop(frame:Dynamic):Void
    {
        stop();
        setFrameByObject(frame);
    }
    
    public function nextFrame():Void
    {
        _currentFrame++;
        
        if (_currentFrame >= _framesCount) 
            _currentFrame = 0;
        
        _currentFrameData = frames[_currentFrame];
    }
    
    public function prevFrame():Void
    {
        _currentFrame--;
        
        if (_currentFrame < 0) 
            _currentFrame = _framesCount - 1;
        
        _currentFrameData = frames[_currentFrame];
    }
	
    inline public function setFrameByObject(frame:Dynamic):Void
    {
        if (Std.is(frame, String)) 
            _currentFrame = lablesMap.get(cast frame);
        else 
        {
            _currentFrame = cast frame;
        }
        
        if (_currentFrame >= _framesCount) 
        {
            _currentFrame = _framesCount - 1;
        }
        
        _currentFrameData = frames[_currentFrame];
    }
    
    public function update():Void
    {
        
        var displayObjectsList:Array<DisplayObjectData> = _currentFrameData.displayObjects;
        var displayObjectsCount:Int = displayObjectsList.length;
        
        for (i in 0...displayObjectsCount)
		{
            var currentDisplayObject:DisplayObjectData = displayObjectsList[i];
            
            if (Std.is(currentDisplayObject, IUpdatable)) 
                cast(currentDisplayObject, IUpdatable).update();
        }
        
        if (!_isPlaying) 
            return;
        
        nextFrame();
    }
    
    public function currentFrameData():FrameData
    {
        return _currentFrameData;
    }
    
    public function advanceFrame(delta:Int):Void
    {
        _currentFrame += delta;
        
        if (_currentFrame < 0) 
            _currentFrame = _framesCount - 1;
        
        if (_currentFrame >= _framesCount) 
            _currentFrame = 0;
        
        _currentFrameData = frames[_currentFrame];
    }
    
    private function get_framesCount():Int
    {
        return _framesCount;
    }
    
    private function get_currentFrame():Int
    {
        return _currentFrame;
    }
    
    private function get_isPlaying():Bool
    {
        return _isPlaying;
    }
}
