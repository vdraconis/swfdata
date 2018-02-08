package swfdrawer;

import swfdata.DisplayObjectData;
import swfdrawer.data.DrawingData;

interface IDrawer
{
    function draw(drawable:DisplayObjectData, drawingData:swfdrawer.data.DrawingData):Void;
}