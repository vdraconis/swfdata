package swfdata.atlas;


import flash.display.BitmapData;
import flash.geom.Matrix;

class AtlasDrawerUtils
{
    
    
    
    
    private static var COLOR_BOUND_CHECK_11:BitmapData = new BitmapData(2048, 2048, true, 0);
    private static var COLOR_BOUND_CHECK_10:BitmapData = new BitmapData(1024, 1024, true, 0);
    private static var COLOR_BOUND_CHECK_9:BitmapData = new BitmapData(512, 512, true, 0);
    private static var COLOR_BOUND_CHECK_8:BitmapData = new BitmapData(256, 256, true, 0);
    private static var COLOR_BOUND_CHECK_7:BitmapData = new BitmapData(128, 128, true, 0);
    private static var COLOR_BOUND_CHECK_6:BitmapData = new BitmapData(64, 64, true, 0);
    private static var COLOR_BOUND_CHECK_5:BitmapData = new BitmapData(32, 32, true, 0);
    private static var COLOR_BOUND_CHECK_4:BitmapData = new BitmapData(16, 16, true, 0);
    private static var COLOR_BOUND_CHECK_3:BitmapData = new BitmapData(8, 8, true, 0);
    private static var COLOR_BOUND_CHECK_2:BitmapData = new BitmapData(4, 4, true, 0);
    private static var COLOR_BOUND_CHECK_1:BitmapData = new BitmapData(2, 2, true, 0);
    private static var COLOR_BOUND_CHECK_0:BitmapData = new BitmapData(1, 1, true, 0);
    
    public static var boundCheckers:Array<BitmapData> = [COLOR_BOUND_CHECK_0, COLOR_BOUND_CHECK_1, COLOR_BOUND_CHECK_2, COLOR_BOUND_CHECK_3, 
                COLOR_BOUND_CHECK_4, COLOR_BOUND_CHECK_5, COLOR_BOUND_CHECK_6, COLOR_BOUND_CHECK_7, 
                COLOR_BOUND_CHECK_8, COLOR_BOUND_CHECK_9, COLOR_BOUND_CHECK_10, COLOR_BOUND_CHECK_11];
    
    private static inline var MAX_SIZE:Int = 2048;
    
    public static function getBestPowerOf2(value:Int):Int
    {
        var p:Int = 1;
        
        while (p < value)
        p <<= 1;
        
        if (p > MAX_SIZE) 
            p = MAX_SIZE;
        
        return p;
    }

    public function new()
    {
    }
}

