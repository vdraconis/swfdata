package swfdata;

import swfdata.ITimelineContainer;

interface ITimeline extends ITimelineContainer
{
    
    
    var framesCount(get, never) : Int;    
    var currentFrame(get, never) : Int;    
    
    var isPlaying(get, never) : Bool;

    function play() : Void;
    function gotoAndPlay(frame : Dynamic) : Void;
    
    function stop() : Void;
    function gotoAndStop(frame : Dynamic) : Void;
    
    function nextFrame() : Void;
    function prevFrame() : Void;
    
    function addFrame(frameData : FrameData) : Void;
    function advanceFrame(delta : Int) : Void;
}
