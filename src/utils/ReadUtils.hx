package utils;

import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import swfdata.atlas.TextureTransform;

class ReadUtils 
{

	public function new() 
	{
		
	}
	
	inline public static function roundPixels20(pixels:Float):Float{
        return Math.round(pixels * 100) / 100;
    }
	
	public static function readRectangle(input:ByteArray):Rectangle
    {
        //var bits:uint = input.readBits(5);
		
        var rect:Rectangle = new Rectangle();
        
        //rect.x = (input.readBits(bits));
        //rect.width = (input.readBits(bits));
        //rect.y = (input.readBits(bits));
        //rect.height = (input.readBits(bits));
        
        
        rect.x = roundPixels20(input.readInt() / 20);
        rect.width = roundPixels20(input.readInt() / 20);
        rect.y = roundPixels20(input.readInt() / 20);
        rect.height = roundPixels20(input.readInt() / 20);
        
        //trace('read rect', rect);
        
        //trace('read rectangle', rect);
        
        return rect;
    }
	
	public static function readTextureTransform(input:ByteArray):TextureTransform
    {
        var scaleX:Float = 1;
        var scaleY:Float = 1;
        
        /*	if (input.readBits(1) == 1) 
			{
				var scaleBits:uint = input.readBits(5);
				scaleX = input.readFixedBits(scaleBits);
				scaleY = input.readFixedBits(scaleBits);
			}*/
        
        if (input.readUnsignedByte() == 1) 
        {
            scaleX = input.readInt() / ByteUtils.FIXED_PRECISSION_VALUE;
            scaleY = input.readInt() / ByteUtils.FIXED_PRECISSION_VALUE;
        }  //var translateY:Number = input.readBits(translateBits);    //var translateX:Number = input.readBits(translateBits);    //var translateBits:uint = input.readBits(5);    //input.bitsReader.clear();  

        var translateX:Float = input.readInt();
        var translateY:Float = input.readInt();
        
        //trace('read transform', scaleX, scaleY, translateX / 2000, translateY / 2000);
        
        return new TextureTransform(scaleX, scaleY, translateX / 2000, translateY / 2000);
    }
	
	public static function writeRectangle(output:ByteArray, rectangle:Rectangle):Void
    {
        var xmin:Int = Std.int(rectangle.x * 20);
        var xmax:Int = Std.int(rectangle.width * 20);
        var ymin:Int = Std.int(rectangle.y * 20);
        var ymax:Int = Std.int(rectangle.height * 20);
        
        //if (xmin < 0 || ymin < 0 || xmax < 0 || ymax < 0)
        //throw new Error("value range error: " + xmin + ", " + ymin + ", " + xmax + ", " + ymax);
        
        var numBits:Int = ByteUtils.calculateMaxBits4(true, xmin, xmax, ymin, ymax);
        
        //output.writeBits(numBits, 5);
        //output.writeBits(xmin, numBits);
        //output.writeBits(xmax, numBits);
        //output.writeBits(ymin, numBits);
        //output.writeBits(ymax, numBits);
        
        output.writeInt(xmin);
        output.writeInt(xmax);
        output.writeInt(ymin);
        output.writeInt(ymax);
    }
    
    public static function writeTextureTransform(output:ByteArray, transform:TextureTransform):Void
    {
        var translateX:Int = Std.int(transform.tx * 2000);
        var translateY:Int = Std.int(transform.ty * 2000);
        
        var scaleX:Float = transform.scaleX;
        var scaleY:Float = transform.scaleY;
        
        var hasScale:Bool = (scaleX != 1) || (scaleY != 1);
        
        //output.writeBits(hasScale ? 1:0, 1);
        output.writeUnsignedInt((hasScale) ? 1:0);
        if (hasScale) 
        {
            /*var scaleBits:uint;
				if (scaleX == 0 && scaleY == 0) 
				{
					scaleBits = 1;
				} 
				else 
				{
					scaleBits = ByteArrayUtils.calculateMaxBits(true, scaleX * Constants.FIXED_PRECISSION_VALUEE, scaleY * Constants.FIXED_PRECISSION_VALUEE);
				}
				
				if (scaleX < 0 || scaleY < 0)
					throw new Error("value range error: " + scaleX + ", " + scaleY);
				
				output.writeBits(scaleBits, 5);
				output.writeFixedBits(scaleX, scaleBits);
				output.writeFixedBits(scaleY, scaleBits);*/
            
            output.writeInt(Std.int(scaleX * ByteUtils.FIXED_PRECISSION_VALUE));
            output.writeInt(Std.int(scaleY * ByteUtils.FIXED_PRECISSION_VALUE));
        }  //output.writeBits(translateY, translateBits);    //output.writeBits(translateX, translateBits);    //output.writeBits(translateBits, 5);    //var translateBits:uint = ByteArrayUtils.calculateMaxBits(true, translateX, translateY);    //output.end(false);  
        
        output.writeInt(translateX);
        output.writeInt(translateY);
    }
	
}