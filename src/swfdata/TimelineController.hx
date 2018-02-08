package swfdata;

@:access(swfdata)
class TimelineController implements ITimelineController
{
	public var framesCount(get, never):Int;
    public var currentFrame(get, never):Int;
    public var currentFrameData(get, never):FrameData;
    public var isPlaying(get, never):Bool;

    var _isPlaying:Bool = true;
	@:allow(swfdata)
	var _currentFrame:Int = 0;
	@:allow(swfdata)
	var _currentFrameData:FrameData;
	
    var currentLable:String;
	var timeline:Timeline;
    
    public function new(timeline:Timeline)
    {
		this.timeline = timeline;
		_currentFrameData = timeline.getFrameByIndex(_currentFrame);
    }
	
	function get_framesCount():Int
    {
        return timeline._framesCount;
    }
    
    function get_currentFrame():Int
    {
        return _currentFrame;
    }
    
    function get_isPlaying():Bool
    {
        return _isPlaying;
    }
		
	public function onAddFrame() 
	{
		if (_currentFrameData == null)
			_currentFrameData = timeline._currentFrameData;
	}
    
    public function gotoAndPlayAll(frameIndex:Int):Void
    {
        gotoAndPlay(frameIndex);
        
        for (i in 0...framesCount){
            timeline.gotoAndPlayAll(frameIndex);
        }
    }
    
    public function gotoAndStopAll(frameIndex:Int):Void
    {
        gotoAndStop(frameIndex);
        
        for (i in 0...framesCount){
            timeline.gotoAndStopAll(frameIndex);
        }
    }
    
    public function play():Void
    {
        this._isPlaying = true;
		_currentFrameData = timeline.getFrameByIndex(_currentFrame);
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
        
        if (_currentFrame >= framesCount) 
            _currentFrame = 0;
        
        _currentFrameData = timeline.getFrameByIndex(_currentFrame);
    }
	
	public function advanceFrame(delta:Int):Void
    {
        _currentFrame += delta;
        
        if (_currentFrame < 0) 
            _currentFrame = framesCount - 1;
        
        if (_currentFrame >= framesCount) 
            _currentFrame = 0;
        
        _currentFrameData = timeline.getFrameByIndex(_currentFrame);
    }
    
    public function prevFrame():Void
    {
        _currentFrame--;
        
        if (_currentFrame < 0) 
            _currentFrame = framesCount - 1;
        
        _currentFrameData = timeline.getFrameByIndex(_currentFrame);
    }
	
    inline public function setFrameByObject(frame:Dynamic):Void
    {
        if (Std.is(frame, String)) 
            _currentFrame = timeline.lablesMap.get(cast frame);
        else 
        {
            _currentFrame = cast frame;
        }
        
        if (_currentFrame >= framesCount) 
        {
            _currentFrame = framesCount - 1;
        }
        
        _currentFrameData = timeline.getFrameByIndex(_currentFrame);
    }
    
    public function update():Void
    {
		 if (_isPlaying) 
			nextFrame();
		
        var displayObjectsList:Array<DisplayObjectData> = _currentFrameData.displayObjects;
        var displayObjectsCount:Int = _currentFrameData.displayObjectsPlacedCount;
        
        for (i in 0...displayObjectsCount)
		{
            var currentDisplayObject:DisplayObjectData = displayObjectsList[i];
            
            if (Std.is(currentDisplayObject, IUpdatable)) 
                cast(currentDisplayObject, IUpdatable).update();
        }
    }
    
    public function get_currentFrameData():FrameData
    {
        return _currentFrameData;
    }
	
	public function destroy():Void
    {
		
    }
}