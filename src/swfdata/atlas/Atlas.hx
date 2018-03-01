package swfdata.atlas;

import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.display.StageQuality;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import swfdata.atlas.SubTexture;
import swfdata.atlas.TextureTransform;

class Atlas
{
    public static var NULL_POINT:Point = new Point();
    
    private static var DRAWING_MATRIX:Matrix = new Matrix();
    
    private static var COLOR_BOUND_CHECK_10:BitmapData = new BitmapData(1024, 1024, true, 0);
    private static var COLOR_BOUND_CHECK_9:BitmapData = new BitmapData(512, 512, true, 0);
    private static var COLOR_BOUND_CHECK_8:BitmapData = new BitmapData(256, 256, true, 0);
    private static var COLOR_BOUND_CHECK_7:BitmapData = new BitmapData(128, 128, true, 0);
    private static var COLOR_BOUND_CHECK_6:BitmapData = new BitmapData(64, 64, true, 0);
    private static var COLOR_BOUND_CHECK_5:BitmapData = new BitmapData(32, 32, true, 0);
    private static var COLOR_BOUND_CHECK_4:BitmapData = new BitmapData(16, 16, true, 0);
    private static var COLOR_BOUND_CHECK_3:BitmapData = new BitmapData(8, 8, true, 0);
    private static var COLOR_BOUND_CHECK_2:BitmapData = new BitmapData(4, 4, true, 0);
    private static var COLOR_BOUND_CHECK_1:BitmapData = new BitmapData(2, 2, true, 0);
    private static var COLOR_BOUND_CHECK_0:BitmapData = new BitmapData(1, 1, true, 0);
    
    private static var boundCheckers:Array<BitmapData> = [COLOR_BOUND_CHECK_0, COLOR_BOUND_CHECK_1, COLOR_BOUND_CHECK_2, COLOR_BOUND_CHECK_3, 
                COLOR_BOUND_CHECK_4, COLOR_BOUND_CHECK_5, COLOR_BOUND_CHECK_6, COLOR_BOUND_CHECK_7, 
                COLOR_BOUND_CHECK_8, COLOR_BOUND_CHECK_9, COLOR_BOUND_CHECK_10];
    
    private static inline var MAX_SIZE:Int = 512;
    
    public static function getBestPowerOf2(value:Int):Int
    {
        var p:Int = 1;
        
        while (p < value)
        p <<= 1;
        
        if (p > MAX_SIZE) 
            p = MAX_SIZE;
        
        return p;
    }
    
    public var atlasData:BitmapData = new BitmapData(1024 * 2, 1024 * 2, true, 0);  //0x55000011);  
    //public var atlasData:BitmapData = new BitmapData(1024 * 8, 1024 * 8, true, 0);//0x55000011);
    private var lastPosition:Point = new Point();
    
    public var subTextures:Dynamic = { };
    private var padding:Int;
    
    public var scale:Float;
    
    public function new(scale:Float = 1, padding:Int = 1)
    {
        
        this.padding = padding;
        this.scale = scale;
        lastPosition.setTo(padding, padding);
    }
    
    public function getSubTexture(shapeId:Int):SubTexture
    {
        return subTextures[shapeId];
    }
    
    private var maxPadding:Float = 0;
    public function addShape(shapeId:Int, shape:Shape, defineRect:Rectangle, sceneTransfrm:TextureTransform):Rectangle
    {
        var shapeBound:Rectangle = defineRect.clone();
        
        DRAWING_MATRIX.identity();
        
        var scaleX:Float = sceneTransfrm.scaleX = sceneTransfrm.scaleX * scale;
        var scaleY:Float = sceneTransfrm.scaleY = sceneTransfrm.scaleY * scale;
        sceneTransfrm.recalculate();
        var subtexture:SubTexture = new SubTexture(shapeId, shapeBound, scaleX, scaleY);
        
        var posX:Float = lastPosition.x - defineRect.x;
        
        if (posX + defineRect.width * scaleX + padding >= atlasData.width) 
        {
            lastPosition.setTo(padding, lastPosition.y + maxPadding + padding);
            maxPadding = 2;
        }  //scaleY = Number(scaleY.toFixed(2));    //scaleX = Number(scaleX.toFixed(2));  
        
        
        
        
        
        
        DRAWING_MATRIX.scale(scaleX, scaleY);
        shapeBound.width *= scaleX;
        shapeBound.height *= scaleY;
        
        DRAWING_MATRIX.tx = -sceneTransfrm.tx * scaleX + 20;
        DRAWING_MATRIX.ty = -sceneTransfrm.ty * scaleY + 10;
        
        var powerOf2Size:Int = getBestPowerOf2(Math.max(shapeBound.width + 40, shapeBound.height + 20));
        var checkerIndex:Int = FastMath.log(powerOf2Size, 2);
        
        var boundChecker:BitmapData = boundCheckers[checkerIndex];
        
        boundChecker.drawWithQuality(shape, DRAWING_MATRIX, null, null, null, false, StageQuality.BEST);
        
        var bitmapBoundRect:Rectangle = boundChecker.getColorBoundsRect(0xFFFFFFFF, 0, false);
        
        shapeBound.width = bitmapBoundRect.width;
        shapeBound.height = bitmapBoundRect.height;
        shapeBound.x = lastPosition.x;
        shapeBound.y = lastPosition.y;
        
        //atlasData.fillRect(shapeBound, 0x33FF0000);
        atlasData.copyPixels(boundChecker, bitmapBoundRect, lastPosition);
        
        boundChecker.fillRect(bitmapBoundRect, 0);
        
        
        maxPadding = Math.max(maxPadding, shapeBound.height);
        lastPosition.x += shapeBound.width + padding * 2;
        subTextures[shapeId] = subtexture;
        
        return bitmapBoundRect;
    }
}