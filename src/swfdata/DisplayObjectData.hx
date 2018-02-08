package swfdata;

import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import swfdata.atlas.ITextureAtlas;

class DisplayObjectData
{
    public var alpha(get, set):Float;
    public var x(get, set):Float;
    public var y(get, set):Float;

    private var isCalculatedInPrevFrame:Bool = false;
    
    public var prototypeDisplayObjectData:DisplayObjectData;
    
    //public var layer:LayerData;
    //public var frameData:FrameObjectData;
	
	public var atlas:ITextureAtlas;
    
    public var depth:Int = -1;
    public var clipDepth:Int = 0;
    
    public var characterId:Int;
    public var libraryLinkage:String;
    
    var _x:Float = 0;
    var _y:Float = 0;
    
    public var transform:Matrix;
    
    public var bounds:Rectangle = new Rectangle();
    
    public var colorTransform:ColorMatrix;  // = new ColorTransform();  
    
	@:allow(swfdata) var colorData:ColorData;
	@:allow(swfdata) var displayObjectType:Int;
    
    public var isMask:Bool;
    public var mask:DisplayObjectData;
    
    public var hasMoved:Bool = false;
    public var hasPlaced:Bool = false;
    
    public var name:String;
	public var visible:Bool = true;
	
	public var isUnderMouse:Bool = false;
    
    
    public function new(characterId:Int = -1, displayObjectType:Int = DisplayObjectTypes.DISPALY_OBJECT_TYPE)
    {
        this.displayObjectType = displayObjectType;
        this.characterId = characterId;
    }
    
    function set_alpha(value:Float):Float
    {
        colorData.a = value;
        return value;
    }
    
    function get_alpha():Float
    {
        return colorData.a;
    }
    
    public function destroy():Void
    {
        prototypeDisplayObjectData = null;
        mask = null;
        colorTransform = null;
        transform = null;
        name = null;
        libraryLinkage = null;
    }
    
    public function setTransformMatrix(matrix:Matrix):Void
    {
        transform = matrix;
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
    }
    
    function get_x():Float
    {
        return _x;
    }
    
    function set_x(value:Float):Float
    {
        _x = value;
        return value;
    }
    
    function get_y():Float
    {
        return _y;
    }
    
    function set_y(value:Float):Float
    {
        _y = value;
        return value;
    }
    
    //public function draw(graphics:Graphics, color:uint):void
    //{
    //	graphics.lineStyle(1, 0);
    //	graphics.beginFill(color, 0.5);
    
    //	graphics.moveTo(bounds.resultTopLeft.x, bounds.resultTopLeft.y);
    //	graphics.lineTo(bounds.resultTopRight.x, bounds.resultTopRight.y);
    //	graphics.lineTo(bounds.resultBottomRight.x, bounds.resultBottomRight.y);
    //	graphics.lineTo(bounds.resultBottomLeft.x, bounds.resultBottomLeft.y);
    //	graphics.lineTo(bounds.resultTopLeft.x, bounds.resultTopLeft.y);
    
    //	graphics.lineStyle();
    //	graphics.endFill();
    //}
    
    public function fillFrom(displayObject:DisplayObjectData):Void
    {
        setTransformFromMatrix(displayObject.transform);
        //setTransformMatrix(displayObject.transform);
        
        isMask = displayObject.isMask;
        
        if (displayObject.name != null) 
            name = displayObject.name;
        
        if (displayObject.libraryLinkage != null) 
            libraryLinkage = displayObject.libraryLinkage;
    }
    
    function setDataTo(objectCloned:DisplayObjectData):Void
    {
        objectCloned.atlas = atlas;
        objectCloned.name = name;
        objectCloned.depth = depth;
        objectCloned.characterId = characterId;
        objectCloned.libraryLinkage = libraryLinkage;
        objectCloned.prototypeDisplayObjectData = prototypeDisplayObjectData;
        objectCloned.colorTransform = colorTransform;
        objectCloned.isMask = isMask;
        objectCloned.mask = mask;
        objectCloned._x = _x;
        objectCloned._y = _y;
    }
    
    public function deepClone():DisplayObjectData
    {
        return this;
    }
    
    public function clone():DisplayObjectData
    {
        var objectCloned:DisplayObjectData = new DisplayObjectData();
        setDataTo(objectCloned);
        
        return objectCloned;
    }
}