package swfdata;

import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import swfdata.atlas.ITextureAtlas;
import swfdata.atlas.TextureId;

using swfdata.DisplayObjectData;

class DisplayObjectData
{
    public var alpha(get, set):Float;
    public var x(get, set):Float;
    public var y(get, set):Float;

    private var isCalculatedInPrevFrame:Bool = false;
    
    public var prototypeDisplayObjectData:DisplayObjectData;
    
    //public var layer:LayerData;
    //public var frameData:FrameObjectData;
    
    public var depth:Int = -1;
    public var clipDepth:Int = 0;
    
    public var characterId:TextureId;
    public var libraryLinkage:String;
    
    public var transform:Matrix;
    
    public var bounds:Rectangle = new Rectangle();
    
    public var colorTransform:ColorMatrix;  // = new ColorTransform();  
    
	@:allow(swfdata) var colorData:ColorData;
	@:allow(swfdata) var displayObjectType:Int;
    
    public var isMask:Bool = false;
    public var mask:DisplayObjectData;
    
    public var hasMoved:Bool = false;
    public var hasPlaced:Bool = false;
    
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
        prototypeDisplayObjectData = null;
        mask = null;
        colorTransform = null;
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
    
    inline public static function setDataFrom(to:DisplayObjectData, from:DisplayObjectData):Void
    {
        to.name = from.name;
        to.depth = from.depth;
        to.characterId = from.characterId;
        to.libraryLinkage = from.libraryLinkage;
        to.prototypeDisplayObjectData = from.prototypeDisplayObjectData;
        to.colorTransform = from.colorTransform;
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