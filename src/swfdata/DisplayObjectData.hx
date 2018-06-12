package swfdata;

import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import swfdata.atlas.TextureId;

using swfdata.DisplayObjectData;

class DisplayObjectData
{
    public var alpha(get, set):Float;
    public var x(get, set):Float;
    public var y(get, set):Float;
    public var scaleX(get, set):Float;
    public var scaleY(get, set):Float;
    public var rotation(get, set):Float;
	
	var _x:Float = 0;
	var _y:Float = 0;
	
	var _rotation:Float = 0;
	
	var _scaleX:Float = 1;
	var _scaleY:Float = 1;
	
	var rotationCosine:Float = 0;
	var rotationSine:Float = 0;
    
    //public var layer:LayerData;
    //public var frameData:FrameObjectData;
    
    public var depth:Int = -1;
    public var clipDepth:Int = 0;
    
    public var characterId:TextureId;
    public var libraryLinkage:String;
    
    public var transform:Matrix;
    
    public var bounds:Rectangle = new Rectangle();
    
    //public var colorMatrix:ColorMatrix;  // = new ColorTransform();  
    
	public var colorData:ColorData;
	@:allow(swfdata) var displayObjectType:Int;
    
    public var isMask:Bool = false;
    public var mask:DisplayObjectData;
    
    public var name:String = null;
    public var blendMode:Int = 0;
    public var visible:Bool = true;
	
	public var isUnderMouse:Bool = false;
    
    public function new(characterId:TextureId = -1, displayObjectType:Int = DisplayObjectTypes.DISPALY_OBJECT_TYPE)
    {
        this.displayObjectType = displayObjectType;
        this.characterId = characterId;
    }
    
    function set_alpha(value:Float):Float
    {
        colorData.alphaMultiplier = value;
        return value;
    }
    
    function get_alpha():Float
    {
        return colorData.alphaMultiplier;
    }
    
    public function destroy():Void
    {
        mask = null;
        //colorMatrix = null;
        transform = null;
        name = null;
        libraryLinkage = null;
    }

	public function setColorData(mr:Float = 1, mg:Float = 1, mb:Float = 1, ma:Float = 1, ar:Int = 0, ag:Int = 0, ab:Int = 0, aa:Int = 0)
	{
		if (colorData == null)
			colorData = new ColorData(mr, mg, mb, ma, ar, ag, ab, aa);
		else
			colorData.setTo(mr, mg, mb, ma, ar, ag, ab, aa);
	}
    
    public function setTransformMatrix(matrix:Matrix):Void
    {
        transform = matrix;
		calculateTransform(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
    }
    
    public function setTransformFromMatrix(matrix:Matrix):Void
    {
        setTransformFromRawMatrix(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
    }
    
    public function setTransformFromRawMatrix(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void
    {
        if (transform == null) 
        {
            transform = new Matrix(a, b, c, d, tx, ty);
        }
        else 
        {
            transform.setTo(a, b, c, d, tx, ty);
        }
		
		calculateTransform(a, b, c, d, tx, ty);
    }
	
	function calculateTransform(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float)
	{
		if (b == 0)
			_scaleX = a;
		else
			_scaleX = Math.sqrt (a * a + b * b);
			
		if (c == 0) 
			_scaleY = a;
		else
			_scaleY = Math.sqrt (c * c + d * d);
			
		_rotation = (180 / Math.PI) * Math.atan2 (d, c) - 90;
		var radians = _rotation * (Math.PI / 180);
		rotationSine = Math.sin(radians);
		rotationCosine = Math.cos(radians);
		
		this._x = tx;
		this._y = ty;
	}
    
    function get_x():Float
    {
        return transform.tx;
    }
    
    function set_x(value:Float):Float
    {
        transform.tx = value;
        return value;
    }
    
    function get_y():Float
    {
        return transform.ty;
    }
    
    function set_y(value:Float):Float
    {
        transform.ty = value;
        return value;
    }
	
	function get_scaleY():Float
    {
        return _scaleY;
    }
    
    function set_scaleY(value:Float):Float
    {
        if (value != _scaleY)
		{
			_scaleY = value;
			
			if (transform.c == 0)
			{
				transform.d = value;
			} 
			else
			{
				transform.c = -rotationSine * value;
				transform.d = rotationCosine * value;
			}
		}
		
        return value;
    }
	
	function get_scaleX():Float
    {
        return _scaleX;
    }
	
	function set_scaleX(value:Float):Float
    {
        if (value != _scaleX) 
		{
			_scaleX = value;
			
			if (transform.b == 0) 
			{
				transform.a = value;
			} 
			else
			{
				transform.a = rotationCosine * value;
				transform.b = rotationSine * value;
			}
		}
		
        return value;
    }
    
    function get_rotation():Float
    {
        return _rotation;
    }
    
    function set_rotation(value:Float):Float
    {
		if (_rotation != value) 
		{
			_rotation = value;
			var radians = _rotation * (Math.PI / 180);
			rotationSine = Math.sin(radians);
			rotationCosine = Math.cos(radians);
			
			transform.a = rotationCosine * _scaleX;
			transform.b = rotationSine * _scaleX;
			transform.c = -rotationSine * _scaleY;
			transform.d = rotationCosine * _scaleY;
		}
		
        return value;
    }
    
    public function fillFrom(displayObject:DisplayObjectData):Void
    {
        setTransformFromMatrix(displayObject.transform);
        
        isMask = displayObject.isMask;
        
        if (displayObject.name != null) 
            name = displayObject.name;
        
        if (displayObject.libraryLinkage != null) 
            libraryLinkage = displayObject.libraryLinkage;
    }
    
    inline public static function setDataFrom(to:DisplayObjectData, from:DisplayObjectData):Void
    {
        to.name = from.name;
        to.depth = from.depth;
        to.characterId = from.characterId;
        to.libraryLinkage = from.libraryLinkage;
        //to.colorMatrix = from.colorMatrix;
        to.isMask = from.isMask;
        to.mask = from.mask;
        to.blendMode = from.blendMode;
    }
    
    public function softClone():DisplayObjectData
    {
        var objectCloned:DisplayObjectData = new DisplayObjectData();
        DisplayObjectData.setDataFrom(objectCloned, this);
        
        return objectCloned;
    }
    
    public function clone():DisplayObjectData
    {
        var objectCloned:DisplayObjectData = softClone();
		objectCloned.transform = transform.clone();
		//Clon color transform?
        
        return objectCloned;
    }
}