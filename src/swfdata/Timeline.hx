package swfdata;

import IUpdatable;
import openfl.Vector;

class Timeline implements ITimeline implements ITimelineContainer implements IUpdatable
{
    public var framesCount(get, never):Int;
	
    public var frames:Vector<FrameData>;
    
    public var labelsCount:Int = 0;
    public var lablesMap:Map<String, Int> = new Map<String, Int>();
    public var labelsSize:Map<String, Int> = new Map<String, Int>();
	public var _framesCount:Int = 0;
    
	@:allow(swfdata)
    var _currentFrameData:FrameData;
	var _isPlaying:Bool = true;
    var currentLable:String;
    
    public function new(framesCount:Int)
    {
        _framesCount = framesCount;
        frames = new Vector<FrameData>(_framesCount, true);
    }
	
	public function getFrameByIndex(frameIndex:Int):FrameData
	{
		return frames[frameIndex];
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
        for (i in 0..._framesCount){
            frames[i].gotoAndPlayAll(frameIndex);
        }
    }
    
    public function gotoAndStopAll(frameIndex:Int):Void
    {
        for (i in 0..._framesCount){
            frames[i].gotoAndStopAll(frameIndex);
        }
    }
    
    public function update():Void
    {
        /**var displayObjectsList:Array<DisplayObjectData> = _currentFrameData.displayObjects;
        var displayObjectsCount:Int = displayObjectsList.length;
        
        for (i in 0...displayObjectsCount)
		{
            var currentDisplayObject:DisplayObjectData = displayObjectsList[i];
            
            if (Std.is(currentDisplayObject, IUpdatable)) 
                cast(currentDisplayObject, IUpdatable).update();
        }
        
        if (!_isPlaying) 
            return;
        
        nextFrame();**/
    }
	
    function get_framesCount():Int
    {
        return _framesCount;
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
}