package swfdata.atlas;

class TextureTransform
{
    public var tx:Float;
    public var ty:Float;
    
    public var scaleX:Float;
    public var scaleY:Float;
    
    public var positionMultiplierX:Float;
    public var positionMultiplierY:Float;
    
    public var isMultiplierCalculated:Bool = false;
    
    public function new(scaleX:Float, scaleY:Float, tx:Float = 0, ty:Float = 0)
    {
        this.ty = ty;
        this.tx = tx;
        
        this.scaleY = scaleY;
        this.scaleX = scaleX;
        
        recalculate();
    }
    
    inline public function recalculate():Void
    {
        if (scaleX == 0 || scaleY == 0) 
            return;
        
        isMultiplierCalculated = true;
        positionMultiplierX = 1 / scaleX;
        positionMultiplierY = 1 / scaleY;
        
        if (positionMultiplierX == Math.POSITIVE_INFINITY || positionMultiplierY == Math.POSITIVE_INFINITY) 
            isMultiplierCalculated = false;
    }
    
    public function toString():String
    {
        return "[TextureTransform tx=" + tx + " ty=" + ty + " scaleX=" + scaleX + " scaleY=" + scaleY + " positionMultiplierX=" + positionMultiplierX +
        " positionMultiplierY=" + positionMultiplierY + " isMultiplierCalculated=" + isMultiplierCalculated +
        "]";
    }
}