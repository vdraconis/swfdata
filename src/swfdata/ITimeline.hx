package swfdata;

import swfdata.ITimelineContainer;

interface ITimeline extends ITimelineContainer
{
	var framesCount(get, never):Int;  

	function addFrame(frameData:FrameData):Void;
}