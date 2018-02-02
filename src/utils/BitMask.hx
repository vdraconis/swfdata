package utils;



class BitMask
{
    public var mask:Int;
    
    public function new(mask:Int = 0)
    {
        this.mask = mask;
    }
    
    public function invertBit(bitIndex:Int):Void
    {
        mask ^= (1 << bitIndex);
    }
    
    public function clearBit(bitIndex:Int):Void
    {
        mask &= ~(1 << bitIndex);
    }
    
    @:meta(Inline())

    @:final public function setBit(bitIndex:Int):Void
    {
        mask |= (1 << bitIndex);
    }
    
    @:meta(Inline())

    @:final public function isBitSet(bitIndex:Int):Bool
    {
        return mask & (1 << bitIndex) != 0;
    }
}
