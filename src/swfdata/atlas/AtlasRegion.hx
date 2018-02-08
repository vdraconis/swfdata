package swfdata.atlas;

import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class AtlasRegion
{
    public var masterBitmap:BitmapData;
    
    public var bounds:Rectangle;
    public var width:Int;
    public var height:Int;
    public var areaSize:Int;
    public var name:String;
    
    public function new(bounds:Rectangle, name:String, masterBitmap:BitmapData)
    {
        this.masterBitmap = masterBitmap;
        this.name = name;
        this.bounds = bounds;
        
        width = bounds.width;
        height = bounds.height;
        
        areaSize = width * height;
    }
    
    public function copyTo(destPoint:Point, destBitmap:BitmapData):Void
    {
        
        
    }
}