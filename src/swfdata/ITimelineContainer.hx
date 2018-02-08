package swfdata;

interface ITimelineContainer
{
    function gotoAndPlayAll(frameIndex:Int):Void;
    function gotoAndStopAll(frameIndex:Int):Void;
}