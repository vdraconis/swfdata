package renderer;

import openfl.Vector;
import swfdata.ColorData;
import swfdata.atlas.GLSubTexture;

class DrawingList
{
    static var RGB_VALUE_TO_SHADER:Float = 0.003921568627451;
    
    public var data:Vector<Float>;
	private var __array:Array<Float>;
    
	public var length:Int = 0;
    public var registersSize:Int = 0;
    public var registersMaxSize:Int = 0;
    public var blendMode:Int = 0;
	
	public var isFull:Bool;
	
	public var texture:GLSubTexture;
	
	var registersPerGeometry:Int;
	var setFunc:Dynamic;
	
    public function new(size:Int, registersPerGeometry:Int)
    {
        this.registersPerGeometry = registersPerGeometry;
        registersMaxSize = size;
        data = new Vector(registersMaxSize * 4, true);
		
		__array = untyped this.data.data.__array;
    }
	
    inline public function clear():Void
    {
        length = 0;
        registersSize = 0;
        isFull = false;
    }
    
	inline public function addDrawingData(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float, texture:GLSubTexture, colorData:ColorData)
    {
        this.texture = texture;
		
		var data = __array;
		var length = this.length;
		
		//TODO need another way to set constands data, or special object to isolate data.data.__array access
		data[length++] = a;
        data[length++] = c;
        data[length++] = b;
        data[length++] = d;
        
        data[length++] = tx;
        data[length++] = ty;
        data[length++] = texture.width;
        data[length++] = texture.height;
        
        data[length++] = texture.u;
        data[length++] = texture.v;
        data[length++] = texture.uscale;
        data[length++] = texture.vscale;
        
        data[length++] = colorData.redMultiplier;
        data[length++] = colorData.greenMultiplier;
        data[length++] = colorData.blueMultiplier;
        data[length++] = colorData.alphaMultiplier;
        
        data[length++] = colorData.redAdd * RGB_VALUE_TO_SHADER;
        data[length++] = colorData.greenAdd * RGB_VALUE_TO_SHADER;
        data[length++] = colorData.blueAdd * RGB_VALUE_TO_SHADER;
        data[length++] = colorData.alphaAdd * RGB_VALUE_TO_SHADER;
		
		this.length = length;
        
        registersSize += registersPerGeometry;
        
        isFull = registersSize + registersPerGeometry > registersMaxSize;
    }
}