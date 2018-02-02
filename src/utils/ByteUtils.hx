package utils;

class ByteUtils
{
    public static inline var FIXED_PRECISSION_VALUE:Int = 65536;
    public static var FIXED_PRECISSION_VALUE_MULTIPLIER:Float = 1 / 65536;
	
    private static var LOG_2:Float = Math.log(2);
    
    public function new()
    {
        
        
    }
    
    @:meta(Inline())

    public static function addBitsValue(mask:Int, value:Int):Int
    {
        if (value >= 0) 
            mask |= value
        else 
        mask |= ~value << 1;
        
        return mask;
    }
    
    public static function calculateMaxFixedBits(signed:Bool, a:Float, b:Float):Int
    {
        return calculateMaxBits(signed, Std.int(a * FIXED_PRECISSION_VALUE), Std.int(b * FIXED_PRECISSION_VALUE));
    }
    
    public static function calculateMaxBits(signed:Bool, a:Int, b:Int):Int
    {
        var i:Int = 0;
        var bitMask:Int = 0;
        var valueMax:Int = -2147483648;
        
        if (!signed) 
        {
            bitMask = a | b;
        }
        else 
        {
            bitMask = addBitsValue(bitMask, a);
            bitMask = addBitsValue(bitMask, b);
            
            if (valueMax < a) 
                valueMax = a;
            
            if (valueMax < b) 
                valueMax = b;
        }
        
        var bits:Int = 0;
        if (bitMask > 0) 
        {
            bits = calculateBits(bitMask);
            if (signed && valueMax > 0 && calculateBits(valueMax) >= bits) 
            {
                bits++;
            }
        }
        
        return bits;
    }
    
    
    public static function calculateMaxBits4(signed:Bool, a:Int, b:Int, c:Int, d:Int):Int
    {
        var i:Int = 0;
        var bitMask:Int = 0;
        var valueMax:Int = -2147483648;
        
        if (!signed) 
        {
            bitMask = a | b | c | d;
        }
        else 
        {
            bitMask = addBitsValue(bitMask, a);
            bitMask = addBitsValue(bitMask, b);
            bitMask = addBitsValue(bitMask, c);
            bitMask = addBitsValue(bitMask, d);
            
            if (valueMax < a) 
                valueMax = a;
            
            if (valueMax < b) 
                valueMax = b;
            
            if (valueMax < c) 
                valueMax = c;
            
            if (valueMax < d) 
                valueMax = d;
        }
        
        var bits:Int = 0;
        if (bitMask > 0) 
        {
            bits = calculateBits(bitMask);
            if (signed && valueMax > 0 && calculateBits(valueMax) >= bits) 
            {
                bits++;
            }
        }
        
        return bits;
    }
    
    @:meta(Inline())

    public static function calculateBits(value:Int):Int
    {
        if (value == 0) 
            return 1;
        
        return Math.floor((Math.log(Std.int(value)) / LOG_2) + 1);
    }
    
    @:meta(Inline())

    public static function clampBitsToMaxBytes(value:Int):Int
    {
        var valueBitsSize:Int = calculateBits(value);
        
        if (valueBitsSize < 8) 
            return 1
        else if (valueBitsSize < 17) 
            return 2
        else if (valueBitsSize < 25) 
            return 3
        else if (valueBitsSize < 33) 
            return 4;
        
        return 0;
    }
}
