package swfdata.datatags;

import swfdata.ColorMatrix;

class SwfPackerTagPlaceObject extends SwfPackerTag
{
    public static var PLACE_MODE_UNKNOWN:Int = -1;
    public static inline var PLACE_MODE_PLACE:Int = 0;
    public static inline var PLACE_MODE_REPLACE:Int = 1;
    public static inline var PLACE_MODE_MOVE:Int = 2;
    
    //public var hasClipActions:Boolean;
    public var hasClipDepth:Bool;
    public var hasName:Bool;
    //public var hasRatio:Boolean;
    public var hasColorTransform:Bool;
    public var hasBlendMode:Bool;
    public var hasMatrix:Bool;
    public var hasCharacter:Bool;
    public var hasMove:Bool;
    //public var hasVisible:Boolean;
    //public var hasImage:Boolean;
    //public var hasBlendMode:Boolean;
    //public var hasFilterList:Boolean;
    
    public var characterId:Int;
    public var depth:Int;
    //public var matrix:Matrix;
    
    //matrix
    public var a:Float = 1;
    public var b:Float = 0;
    public var c:Float = 0;
    public var d:Float = 1;
    public var tx:Float = 0;
    public var ty:Float = 0;
    //matrix
	
	public var redMultiplier:Float = 1;
	public var greenMultiplier:Float = 1;
	public var blueMultiplier:Float = 1;
	public var alphaMultiplier:Float = 1;
	
	public var redAdd:Int = 255;
	public var greenAdd:Int = 255;
	public var blueAdd:Int = 255;
	public var alphaAdd:Int = 255;
	
	public var blendMode:Int;	
    
    /*public var redColor0:Float = 0;
    public var redColor1:Float = 0;
    public var redColor2:Float = 0;
    public var redColor3:Float = 0;
    public var redColorOffset:Float = 0;
    
    public var greenColor0:Float = 0;
    public var greenColor1:Float = 0;
    public var greenColor2:Float = 0;
    public var greenColor3:Float = 0;
    public var greenColorOffset:Float = 0;
    
    public var blueColor0:Float = 0;
    public var blueColor1:Float = 0;
    public var blueColor2:Float = 0;
    public var blueColor3:Float = 0;
    public var blueColorOffset:Float = 0;
    
    public var alpha0:Float = 0;
    public var alpha1:Float = 0;
    public var alpha2:Float = 0;
    public var alpha3:Float = 0;
    public var alphaOffset:Float = 0;
    
    
    public function toColorMatrixString():String
    {
        return "[Tag#ColorMatrix" +
        "\n" + redColor0 + "\t" + redColor1 + "\t" + redColor2 + "\t" + redColor3 + "\t" + redColorOffset +
        "\n" + greenColor0 + "\t" + greenColor1 + "\t" + greenColor2 + "\t" + greenColor3 + "\t" + greenColorOffset +
        "\n" + blueColor0 + "\t" + blueColor1 + "\t" + blueColor2 + "\t" + blueColor3 + "\t" + blueColorOffset +
        "\n" + alpha0 + "\t" + alpha1 + "\t" + alpha2 + "\t" + alpha3 + "\t" + alphaOffset + "\n]";
    }*/
    
    //public var colorTransform:ColorMatrix;
    
    public var placeMode:Int = PLACE_MODE_UNKNOWN;
    
    // Forward declarations for TagPlaceObject2
    //public var ratio:uint;
    public var instanceName:String;
    public var clipDepth:Int;
    
    // Forward declarations for TagPlaceObject3
    //public var blendMode:int;
    //public var bitmapCache:int;
    //public var bitmapBackgroundColor:int;
    public var visible:Int;
    
    //public var surfaceFilterList:Vector.<*>;
    
    public function isEquals(eqTo:SwfPackerTagPlaceObject):Bool
    {
        return depth == eqTo.depth && characterId == eqTo.characterId && placeMode == eqTo.placeMode && hasMatrix == eqTo.hasMatrix && clipDepth == eqTo.clipDepth && eqTo.instanceName == instanceName;
    }
    
    public function new()
    {
        super();
        type = 4;
    }
    
    override public function clear():Void
    {
        //matrix = null;
        //colorTransform = null;
        instanceName = null;
    }
    
    public function fillData(_placeMode:Int, _depth:Int, _hasClipDepth:Bool, _hasName:Bool, _hasMatrix:Bool, _hasCharacter:Bool, _instanceName:String, _clipDepth:Int, _characterId:Int):Void
    {
        placeMode = _placeMode;
        depth = _depth;
        hasClipDepth = _hasClipDepth;
        hasName = _hasName;
        hasMatrix = _hasMatrix;
        hasCharacter = _hasCharacter;
        instanceName = _instanceName;
        clipDepth = _clipDepth;
        characterId = _characterId;
    }
    
    public function setMatrix(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void
    {
        this.a = a;
        this.b = b;
        this.c = c;
        this.d = d;
        this.tx = tx;
        this.ty = ty;
    }
    
    /*private var colorMatrix:ColorMatrix;
    
    public function getColorTransformMatrix():ColorMatrix
    {
        if (colorMatrix == null) 
        {
            colorMatrix = new ColorMatrix([
                            redColor0, redColor1, redColor2, redColor3, redColorOffset, 
                            greenColor0, greenColor1, greenColor2, greenColor3, greenColorOffset, 
                            blueColor0, blueColor1, blueColor2, blueColor3, blueColorOffset, 
                            alpha0, alpha1, alpha2, alpha3, alphaOffset]
                    );
        }
        
        return colorMatrix;
    }*/
	
	override public function toString():String
    {
        return "[SwfPackerTagPlaceObject depth=" + depth + " characterId=" + characterId + " placeMode=" + placeMode +
        " hasMatrix=" + hasMatrix + " clipDepth=" + clipDepth + " instanceName=" + instanceName + "]";
    }
}