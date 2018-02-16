package gl.drawer;

import openfl.display.Graphics;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import renderer.GLFilter;
import renderer.Renderer;
import swfdata.ColorData;
import swfdata.DisplayObjectData;
import swfdata.Rectagon;
import swfdata.atlas.GLSubTexture;
import swfdata.atlas.ITextureAtlas;
import swfdata.atlas.TextureTransform;
import swfdrawer.IDrawer;
import swfdrawer.data.DrawingData;

class GLDrawer implements IDrawer
{
    //public static var grassWind:GrassWind = new GrassWind();
    
    //TODO: нужно фильтры все сделать единичными инстансами, а данные для них для каждого конркетного объекта наоборот
    //public var outline:PixelOutline = new PixelOutline();
    
    //public static var colorFilter:ColorFilterSwitch = new ColorFilterSwitch();
    
    //public static var adjustColor:AdjustColor = new AdjustColor();
    
    public var hightlight:Bool = false;
    public var smooth:Bool = true;
    
    private var drawMatrix:Matrix = new Matrix();
    
    public var canvas:Graphics;
    
    //TODO: заменить на объект типа Options с параметрами такого типа
    public var isDebugDraw:Bool = false;
    public var checkMouseHit:Bool = false;
    public var checkBounds:Bool = false;
    public var hitTestResult:Bool = false;
    
    private var currentBoundForDraw:Rectangle = new Rectangle();
    private var drawingRectagon:Rectagon;
    
    private var textureId:Int;
    private var currentSubTexture:GLSubTexture;
    
    private var mousePoint:Point;
    private var transformedMousePoint:Point = new Point();
    
    private var texturePadding:Float;
    private var texturePadding2:Float;
    
    private var textureAtlas:ITextureAtlas;
    
    private var drawingData:DrawingData;
    
    public var isUseGrassWind:Bool = false;
	
	public var renderer:Renderer;
    
    public function new(mousePoint:Point)
    {
        this.mousePoint = mousePoint;
        drawingRectagon = new swfdata.Rectagon(0, 0, 0, 0, drawMatrix);
    }
    
    public function clearMouseHitStatus():Void
    {
        hitTestResult = false;
    }
    
    /**
	 * Apply sub texture draw transform
	 */
	@:access(swfdata)
    public function applyDrawStyle():Void
    {
        //trace('apply daraw', textureId);
        
        currentSubTexture = cast textureAtlas.getTexture(textureId);
        
        var transform:TextureTransform = currentSubTexture._transform;
        var mulX:Float = transform.positionMultiplierX;
        var mulY:Float = transform.positionMultiplierY;
        
        //TODO: если эта дата считается уже в ShapeLibrary и в итоге сохраняется уже умноженой, то поидеи этот момент не нужен
        /**
		 * Т.е
		 * 
		 * Мы берем шейпы как они были например баунд 10, 10, 100, 100
		 * После рисования в аталс и расчета его размеров со скейлом мы выесняем что он рисуется в
		 * 5, 5, 50, 50 размерах
		 * т.к в ShapeLibrary уже посчитан новый размер шейпа и размер текстуры ему соотвествует без скейла то этот скейл сдесь не нужен
		 * 
		 * Далее, для баунда считается хит тест, для этого нужно востановить баунд от скейла, что и делается в коде ниже т.е тут монжо довольно
		 * много операций исключить.
		 * 
		 * Вместе с тем еще можно пивоты текстур сразу сдвинуть в левый врехний угол
		 */
        drawMatrix.a *= mulX;
        drawMatrix.d *= mulY;
        drawMatrix.b *= mulX;
        drawMatrix.c *= mulY;
    }
    
    public function cleanDrawStyle():Void
    {
        textureId = -1;
        currentSubTexture = null;
    }
    
    public function draw(drawable:DisplayObjectData, drawingData:swfdrawer.data.DrawingData):Void
    {
        
        this.drawingData = drawingData;
        
        drawingData.setFromDisplayObject(drawable);
        
        textureId = drawable.characterId;
        this.texturePadding = textureAtlas.padding;
        this.texturePadding2 = textureAtlas.padding * 2;
    }
	
	public function drawDebugInfo()
	{
		if (drawingData.bound != null && hitTestResult)
		{
			canvas.lineStyle(1.6, 0xFF0000, 0.8);
			canvas.drawRect(drawingRectagon.x, drawingRectagon.y, drawingRectagon.width, drawingRectagon.height);
			
			canvas.lineStyle(1.6, 0x00FF00, 0.8);
			canvas.moveTo(drawingRectagon.resultTopLeft.x, drawingRectagon.resultTopLeft.y);
			canvas.lineTo(drawingRectagon.resultTopRight.x, drawingRectagon.resultTopRight.y);
			canvas.lineTo(drawingRectagon.resultBottomRight.x, drawingRectagon.resultBottomRight.y);
			canvas.lineTo(drawingRectagon.resultBottomLeft.x, drawingRectagon.resultBottomLeft.y);
			canvas.lineTo(drawingRectagon.resultTopLeft.x, drawingRectagon.resultTopLeft.y);
		}
	}
	
	public function drawHitBounds(deltaX:Float, deltaY:Float, transformedDrawingX:Float, transformedDrawingY:Float, transformedDrawingWidth:Float, transformedDrawingHeight:Float, transformedPoint:Point)
	{
		var color = hitTestResult? 0xFF0000:Std.int(0xFFFFFF * (currentSubTexture.id / 100));
		
		canvas.lineStyle(1.6, color, 0.8);
		canvas.moveTo(transformedDrawingX + deltaX, transformedDrawingY + deltaY);
		canvas.lineTo(transformedDrawingX + transformedDrawingWidth + deltaX, transformedDrawingY + deltaY);
		canvas.lineTo(transformedDrawingX + transformedDrawingWidth + deltaX, transformedDrawingY + transformedDrawingHeight + deltaY);
		canvas.lineTo(transformedDrawingX + deltaX, transformedDrawingY + transformedDrawingHeight + deltaY);
		canvas.lineTo(transformedDrawingX + deltaX, transformedDrawingY + deltaY);

		canvas.drawCircle(transformedPoint.x + deltaX, transformedPoint.y + deltaY, 5);
	}
    
	inline public function hitTest(pixelPerfect:Bool, texture:GLSubTexture, transformedDrawingX:Float, transformedDrawingY:Float, transformedDrawingWidth:Float, transformedDrawingHeight:Float, transformedPoint:Point):Bool
    {
        var isHit:Bool = false;
        
        //if (transformedPoint.x > transformedDrawingX && transformedPoint.x < transformedDrawingX + transformedDrawingWidth) 
        //    if (transformedPoint.y > transformedDrawingY && transformedPoint.y < transformedDrawingY + transformedDrawingHeight) 
				isHit = true;
        
        if (pixelPerfect && isHit) 
        {
            var u:Float = (transformedPoint.x - transformedDrawingX) / (transformedDrawingWidth + texturePadding2);
            var v:Float = (transformedPoint.y - transformedDrawingY) / (transformedDrawingHeight + texturePadding2);
			
			canvas.beginFill(0xFF0000, 1);
			canvas.drawCircle(texture.getU(u), texture.getV(v), 3);
			canvas.endFill();
            
            isHit = texture.getAlphaAtUV(u, v) > 0x05;
			trace('${texture.getAlphaAtUV(u, v)}, ${transformedPoint}');
        }
        
        return isHit;
    }
    
    
    inline public function setMaskData():Void
    {
        /*var isMask:Bool = drawingData.isMask;
        var isMasked:Bool = drawingData.isMasked;
        
        if (isMask) 
            Genome2D.g2d_instance.g2d_context.renderToStencil(1)
        else if (!isMask && !isMasked) 
        {
            if (Genome2D.g2d_instance.g2d_context.g2d_activeStencilLayer != 0) 
                Genome2D.g2d_instance.g2d_context.renderToColor(0);
        }*/
    }
    
    public function clearMaskData():Void
    {
        //if (drawingData.isMask) 
        //    Genome2D.g2d_instance.g2d_context.renderToColor(1);
    }
    
	@:access(swfdata)
    public function drawRectangle(drawingBounds:Rectangle, transform:Matrix):Void
    {
        drawMatrix.identity();
        drawMatrix.concat(transform);
        
        applyDrawStyle();
        
        var texture:GLSubTexture = currentSubTexture;
        
        var textureTransform:TextureTransform = currentSubTexture._transform;
        
        //TODO: можно вынести в тот же трансформ т.к это нужно всего единажды считать т.к это статические данные
        texture.pivotX = -(drawingBounds.x * textureTransform.scaleX + (texture.width - texturePadding2) / 2);
        texture.pivotY = -(drawingBounds.y * textureTransform.scaleY + (texture.height - texturePadding2) / 2);
        
        setMaskData();
		
        var isMask:Bool = drawingData.isMask;
        var color:ColorData = drawingData.colorData;
        
		if(!isMask)
			renderer.draw(texture, drawMatrix, color, drawingData.blendMode);
			
        clearMaskData();
        
        //transform mesh bounds to deformed mesh
        var transformedDrawingX:Float = drawingBounds.x * currentSubTexture.transform.scaleX - texturePadding;
        var transformedDrawingY:Float = drawingBounds.y * currentSubTexture.transform.scaleY - texturePadding;
        var transformedDrawingWidth:Float = (drawingBounds.width * 2 * currentSubTexture.transform.scaleX) / 2;
        var transformedDrawingHeight:Float = (drawingBounds.height * 2 * currentSubTexture.transform.scaleY) / 2;
        
		if (!isMask && checkBounds || isDebugDraw)
            drawingRectagon.setTo(transformedDrawingX, transformedDrawingY, transformedDrawingWidth, transformedDrawingHeight);
        
        if (!isMask && !hitTestResult && checkMouseHit) 
        {
            //get inversion transform of current mesh and transform mouse point to its local coordinates
            //note doing it after set rectagon because we need not ivnerted transform
            drawMatrix.invert();
            GeomMath.transformPoint(drawMatrix, mousePoint.x, mousePoint.y, false, transformedMousePoint);
            
            hitTestResult = hitTest(true, texture, transformedDrawingX, transformedDrawingY, transformedDrawingWidth, transformedDrawingHeight, transformedMousePoint);
            
            if (isDebugDraw) 
                //may draw debug hit/bound visualisation
				drawHitBounds(400, 150, transformedDrawingX, transformedDrawingY, transformedDrawingWidth, transformedDrawingHeight, transformedMousePoint);
        }
        
		if (isDebugDraw) 
			drawDebugInfo();
        
		/*if (!isMask && checkBounds || isDebugDraw) 
		{
			currentBoundForDraw.setTo(drawingRectagon.x, drawingRectagon.y, drawingRectagon.width, drawingRectagon.height);
			GeomMath.rectangleUnion(drawingData.bound, currentBoundForDraw);
			
			if (isDebugDraw)
			{
				canvas.lineStyle(1, 0x0000FF, 0.5);
				canvas.drawRect(drawingData.bound.x, drawingData.bound.y, drawingData.bound.width, drawingData.bound.height);
			}
		}*/
    }
}
