class FastMath
{
    /**
	 * Return base logarifm of value e.g log(512, 2) Log2(512) - 9
	 * @param	value
	 * @param	base
	 * @return
	 */
    inline public static function log(value:Int, base:Int):Int
    {
        return Std.int(Math.log(value) / Math.log(base));
    }
    
    inline public static function convertToRadian(angle:Float):Float
    {
        return angle * Math.PI / 180;
    }
    
    inline public static function convertToDegree(angle:Float):Float
    {
        return 180 * angle / Math.PI;
    }
    
    inline public static function uintMin(a:Int, b:Int):Int
    {
        return a < b ? a:b;
    }
    
    public static function angle(x1:Float, y1:Float, x2:Float, y2:Float):Float
    {
        x1 = x1 - x2;
        y1 = y1 - y2;
        
        return Math.atan2(x1, y1);
    }
}