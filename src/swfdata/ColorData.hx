package swfdata;

class ColorData
{
	static var availableInstance:ColorData;
	
	inline public static function getWithAndConcat(c1:ColorData, c2:ColorData):ColorData
	{
		var result = getWith(c2);
		result.preMultiply(c1);
		
		return result;
	}
	
	inline public static function getWith(data:ColorData):ColorData
	{
		return get(data.redMultiplier, data.greenMultiplier, data.blueMultiplier, data.alphaMultiplier, data.redAdd, data.greenAdd, data.blueAdd, data.alphaAdd);
	}
	
	inline public static function get(redMultiplier:Float, greenMultiplier:Float, blueMultiplier:Float, alphaMultiplier:Float, redAdd:Int, greenAdd:Int, blueAdd:Int, alphaAdd:Int):ColorData
	{
		var instance:ColorData = ColorData.availableInstance;
		
		if (instance != null)
		{
			ColorData.availableInstance = instance.nextInstance;
			instance.nextInstance = null;
			instance.isFree = false;
			
			instance.setTo(redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier, redAdd, greenAdd, blueAdd, alphaAdd);
		}
		else
		{
			instance = new ColorData(redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier, redAdd, greenAdd, blueAdd, alphaAdd);
		}
		
		return instance;
	}
	
	@:isVar public var color(get, set):Int;
	
	public var isFree:Bool = false;
	public var nextInstance:ColorData;
	
	public var alphaMultiplier:Float = 1;
	public var redMultiplier:Float = 1;
	public var greenMultiplier:Float = 1;
	public var blueMultiplier:Float = 1;
	
	public var alphaAdd:Int = 0;
	public var redAdd:Int = 0;
	public var greenAdd:Int = 0;
	public var blueAdd:Int = 0;
	
	public function new(redMultiplier:Float = 1, greenMultiplier:Float = 1, blueMultiplier:Float = 1, alphaMultiplier:Float = 1, redAdd:Int = 0, greenAdd:Int = 0, blueAdd:Int = 0, alphaAdd:Int = 0)
	{
		this.alphaMultiplier = alphaMultiplier;
		this.blueMultiplier = blueMultiplier;
		this.greenMultiplier = greenMultiplier;
		this.redMultiplier = redMultiplier;
		
		this.redAdd = redAdd;
		this.greenAdd = greenAdd;
		this.blueAdd = blueAdd;
		this.alphaAdd = alphaAdd;
	}
	
	inline public function free()
	{
		if (isFree)
			return;
		
		this.nextInstance = ColorData.availableInstance;
		ColorData.availableInstance = this;
		
		isFree = true;
	}
	
	public function setTo(redMultiplier:Float, greenMultiplier:Float, blueMultiplier:Float, alphaMultiplier:Float, redAdd:Int, greenAdd:Int, blueAdd:Int, alphaAdd:Int)
	{
		this.alphaMultiplier = alphaMultiplier;
		this.redMultiplier = redMultiplier;
		this.greenMultiplier = greenMultiplier;
		this.blueMultiplier = blueMultiplier;
		
		this.redAdd = redAdd;
		this.greenAdd = greenAdd;
		this.blueAdd = blueAdd;
		this.alphaAdd = alphaAdd;
	
		//isUseAdd = redAdd != 0 || greenAdd != 0 || blueAdd != 0 || alphaAdd != 0;
	}
	
	inline public function setFromData(colorData:ColorData)
	{
		alphaMultiplier = colorData.alphaMultiplier;
		redMultiplier = colorData.redMultiplier;
		greenMultiplier = colorData.greenMultiplier;
		blueMultiplier = colorData.blueMultiplier;
		
		redAdd = colorData.redAdd;
		greenAdd = colorData.greenAdd;
		blueAdd = colorData.blueAdd;
		alphaAdd = colorData.alphaAdd;
	}
	
	inline public function clear()
	{
		alphaMultiplier = 1;
		redMultiplier = 1;
		blueMultiplier = 1;
		greenMultiplier = 1;
		
		redAdd = 0;
		greenAdd = 0;
		blueAdd = 0;
		alphaAdd = 0;
	}
	
	inline public function concat(colorData:ColorData)
	{
		alphaMultiplier *= colorData.alphaMultiplier;
		redMultiplier *= colorData.redMultiplier;
		greenMultiplier *= colorData.greenMultiplier;
		blueMultiplier *= colorData.blueMultiplier;
		
		redAdd += colorData.redAdd;
		greenAdd += colorData.greenAdd;
		blueAdd += colorData.blueAdd;
		alphaAdd += colorData.alphaAdd;
	
	}
	
	inline public function preMultiply(colorData:ColorData)
	{
		this.redAdd = Std.int(colorData.redAdd * this.redMultiplier) + this.redAdd;
		this.greenAdd = Std.int(colorData.greenAdd * this.greenMultiplier) + this.greenAdd;
		this.blueAdd = Std.int(colorData.blueAdd * this.blueMultiplier) + this.blueAdd;
		this.alphaAdd = Std.int(colorData.alphaAdd * this.alphaMultiplier) + this.alphaAdd;
		
		this.redMultiplier *= colorData.redMultiplier;
		this.greenMultiplier *= colorData.greenMultiplier;
		this.blueMultiplier *= colorData.blueMultiplier;
		this.alphaMultiplier *= colorData.alphaMultiplier;
	}
	
	public function get_color():Int
	{
		return ((redAdd << 16) | (greenAdd << 8) | blueAdd);
	}
	
	public function set_color(value:Int)
	{
		redAdd = (value >> 16) & 0xFF;
		greenAdd = (value >> 8) & 0xFF;
		blueAdd = value & 0xFF;
		
		redMultiplier = 0;
		greenMultiplier = 0;
		blueMultiplier = 0;
		return value;
	}
	
	public function fillColorMatrix(colorMatrix:ColorMatrix)
	{
		colorMatrix.matrix[0] = redMultiplier;
		colorMatrix.matrix[4] = redAdd / 255;
		colorMatrix.matrix[6] = greenMultiplier;
		colorMatrix.matrix[9] = greenAdd / 255;
		colorMatrix.matrix[12] = blueMultiplier;
		colorMatrix.matrix[14] = blueAdd / 255;
		colorMatrix.matrix[18] = alphaMultiplier;
		colorMatrix.matrix[19] = alphaAdd / 255;
	}
	
	public function toString():String
	{
		return "[ColorData alphaMultiplier=" + alphaMultiplier + " redMultiplier=" + redMultiplier + " greenMultiplier=" + greenMultiplier + " blueMultiplier=" + blueMultiplier + " alphaAdd=" + alphaAdd + " redAdd=" + redAdd + " greenAdd=" + greenAdd + " blueAdd=" + blueAdd + " color=" + color + "]";
	}
}