package swfdata.atlas;

import openfl.display.IBitmapDrawable;
import swfdata.atlas.BitmapSubTexture;
import swfdata.atlas.BitmapTextureAtlas;
import swfdata.atlas.TextureTransform;

import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.StageQuality;
import flash.filters.BlurFilter;
import flash.filters.GlowFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

class AtlasDrawer
{
    public static var NULL_POINT : Point = new Point();
    private static var DRAWING_MATRIX : Matrix = new Matrix();
    
    private var lastPosition : Point = new Point();
    
    public var targetAtlas : BitmapTextureAtlas;
    private var maxPadding : Float = 0;
    
    private var padding : Int;
    private var atlasData : BitmapData;
    public var scale : Float;
    
    public function new(targetAtlas : BitmapTextureAtlas, scale : Float = 1, padding : Int = 4)
    {
        this.targetAtlas = targetAtlas;
        this.padding = padding;
        this.scale = scale;
        atlasData = targetAtlas.atlasData;
        
        clean();
    }
    
    public function clean() : Void
    {
        lastPosition.setTo(padding, padding);
    }
    
    public static function averageColour(source : BitmapData) : Int
    {
        var red : Int = 0;
        var green : Int = 0;
        var blue : Int = 0;
        
        var count : Int = 0;
        var pixel : Int;
        
        for (x in 0...source.width)
		{
            for (y in 0...source.height)
			{
                pixel = source.getPixel(x, y);
                
                if (pixel == 0) 
				{
					continue;
                };
                
                red += pixel >> 16 & 0xFF;
                green += pixel >> 8 & 0xFF;
                blue += pixel & 0xFF;
                
                count++;
            }
        }
        
        red = Std.int(red / count);
        green = Std.int(green / count);
        blue = Std.int(blue / count);
        
        return red << 16 | green << 8 | blue;
    }
    
    public function addShape(shapeId : Int, shape : IBitmapDrawable, defineRect : Rectangle, sceneTransfrm : TextureTransform, drawAdditionalAA : Bool) : Rectangle
    {
        //Клонируется потому что будет далее использован в атласе, но возможно можно тут избежать пары тройки клонов
        var shapeBound : Rectangle = defineRect.clone();
        
        DRAWING_MATRIX.identity();
        
        
        var scaleX : Float;
        var scaleY : Float;
        
        if (scale != 1) 
        {
            //пересчитывает скейл если в атласе нужно рисовать с заданым скейлом а не с 1, 1
            scaleX = sceneTransfrm.scaleX = sceneTransfrm.scaleX * scale;
            scaleY = sceneTransfrm.scaleY = sceneTransfrm.scaleY * scale;
            
            sceneTransfrm.recalculate();
        }
        else 
        {
            scaleX = sceneTransfrm.scaleX;
            scaleY = sceneTransfrm.scaleY;
        }  //Создаем субтекстуру для нового шейпа  
        
        
        
        var subtexture : BitmapSubTexture = new BitmapSubTexture(shapeId, shapeBound, sceneTransfrm);
        
        //позиция в атласе, рисуется просто последовательно до края и переходит на следующую строку
        var posX : Float = lastPosition.x - defineRect.x;
        
        if (posX + defineRect.width * scaleX + padding >= atlasData.width) 
        {
            lastPosition.setTo(padding, lastPosition.y + maxPadding + padding);
            maxPadding = padding;
        }  //на случаей непредвиденых обстоятельств и выбирается подходящий битмап с мнимальным размреом    //определяются размеры которые будут рисоватся, добавляется смещение  
        
        
        
        
        
        DRAWING_MATRIX.scale(scaleX, scaleY);
        shapeBound.width *= scaleX;
        shapeBound.height *= scaleY;
        
        DRAWING_MATRIX.tx = -sceneTransfrm.tx * scaleX + 20;
        DRAWING_MATRIX.ty = -sceneTransfrm.ty * scaleY + 10;
        
        var powerOf2Size:Int = AtlasDrawerUtils.getBestPowerOf2(Std.int(Math.max(shapeBound.width + 40, shapeBound.height + 20)));
        var checkerIndex:Int = Std.int(FastMath.log(powerOf2Size, 2));
        
        
        var boundChecker : BitmapData = AtlasDrawerUtils.boundCheckers[checkerIndex];
        //boundChecker.drawWithQuality(shape, DRAWING_MATRIX, null, null, null, false, StageQuality.BEST);
        boundChecker.draw(shape, DRAWING_MATRIX, null, null, null, false);
        
        if (drawAdditionalAA) 
            boundChecker.applyFilter(boundChecker, boundChecker.rect, new Point(), new GlowFilter(averageColour(boundChecker), 0.8, 2, 2, 2.5));  //после отрисовки в баунд чекерр получает ректанл с видимой областью текстуры    //boundChecker.drawWithQuality(shape, DRAWING_MATRIX, null, null, null, false, StageQuality.BEST);  ;
        
        
        
        
        
        
        var bitmapBoundRect : Rectangle = boundChecker.getColorBoundsRect(0xFFFFFFFF, 0, false);
        
        shapeBound.width = bitmapBoundRect.width;
        shapeBound.height = bitmapBoundRect.height;
        shapeBound.x = lastPosition.x;
        shapeBound.y = lastPosition.y;
        
        
        
        //atlasData.applyFilter(boundChecker, bitmapBoundRect, lastPosition.add(new Point(-bitmapBoundRect.width/2, -bitmapBoundRect.height/2)), new BlurFilter(6, 6, 1));
        //рисуем получившуюся текстуру в атлас
        atlasData.copyPixels(boundChecker, bitmapBoundRect, lastPosition);
        
        boundChecker.fillRect(bitmapBoundRect, 0);
        
        //высчитываем смещение x, y расчитаное из колор баунд ректа т.е это смещение с верху и с лева которое не будет нарисовано
        //trace('pre tt', bitmapBoundRect.x, bitmapBoundRect.y);
        bitmapBoundRect.x = bitmapBoundRect.x - DRAWING_MATRIX.tx;
        bitmapBoundRect.y = bitmapBoundRect.y - DRAWING_MATRIX.ty;
        
        
        //trace(bitmapBoundRect);
        
        maxPadding = Math.max(maxPadding, shapeBound.height);
        lastPosition.x += shapeBound.width + padding * 2;
        
        targetAtlas.putTexture(subtexture);
        
        return bitmapBoundRect;
    }
}
