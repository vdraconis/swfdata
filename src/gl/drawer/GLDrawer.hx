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
import swfdata.atlas.TextureStorage;
import swfdata.atlas.TextureTransform;
import swfdrawer.IDrawer;
import swfdrawer.data.DrawingData;

class GLDrawer implements IDrawer
{
    
    public var hightlight:Bool = false;
    public var smooth:Bool = true;
    
    private var drawMatrix:Matrix = new Matrix();
    
    public var convas:Graphics;
    
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
    
    private var textureStorage:TextureStorage;
    
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
    
	@:access(swfdata) inline public function applyDrawStyle():Void
    {
        //trace('apply daraw', textureId);
        
        currentSubTexture = Lang.as2(textureStorage.getGexture(textureId), GLSubTexture);
        
        var transform:TextureTransform = currentSubTexture.transform;
        var mulX:Float = transform.positionMultiplierX;
        var mulY:Float = transform.positionMultiplierY;
        
        drawMatrix.a *= mulX;
        drawMatrix.d *= mulY;
        drawMatrix.b *= mulX;
        drawMatrix.c *= mulY;
		
        this.texturePadding2 = currentSubTexture.padding * 2;
    }
    
    public function draw(drawable:DisplayObjectData, drawingData:swfdrawer.data.DrawingData):Void
    {
        this.drawingData = drawingData;
        
        drawingData.setFromDisplayObject(drawable);
        
        textureId = drawable.characterId;
    }
    
	inline public function hitTest(pixelPerfect:Bool, texture:GLSubTexture, transformedDrawingX:Float, transformedDrawingY:Float, transformedDrawingWidth:Float, transformedDrawingHeight:Float, transformedPoint:Point):Bool
    {
        var isHit:Bool = false;
        
        if (transformedPoint.x > transformedDrawingX && transformedPoint.x < transformedDrawingX + transformedDrawingWidth) 
            if (transformedPoint.y > transformedDrawingY && transformedPoint.y < transformedDrawingY + transformedDrawingHeight) 
				isHit = true;
        
        if (pixelPerfect && isHit) 
        {
            var u:Float = (transformedPoint.x - transformedDrawingX) / (transformedDrawingWidth + texturePadding2);
            var v:Float = (transformedPoint.y - transformedDrawingY) / (transformedDrawingHeight + texturePadding2);
            
            isHit = texture.getAlphaAtUV(u, v) > 0x05;
        }
        
        return isHit;
    }
    
	@:access(swfdata) public function drawRectangle(drawingBounds:Rectangle, transform:Matrix):Void
    {
        drawMatrix.identity();
		
        //drawMatrix.concatInline(transform);
        drawMatrix.concat(transform);

        applyDrawStyle();
        
        var texture:GLSubTexture = currentSubTexture;
        
        var textureTransform:TextureTransform = currentSubTexture.transform;
		var textureScaleX = textureTransform.scaleX;
		var textureScaleY = textureTransform.scaleY;
		
		var drawingBoundsX = drawingBounds.x;
		var drawingBoundsY = drawingBounds.y;
		var drawingBoundsWidth = drawingBounds.width;
		var drawingBoundsHeight = drawingBounds.height;
        
        texture.pivotX = -(drawingBoundsX * textureScaleX + (texture.width - texturePadding2) / 2);
        texture.pivotY = -(drawingBoundsY * textureScaleY + (texture.height - texturePadding2) / 2);
		
        var isMask:Bool = drawingData.isMask;
        
        var color:ColorData = drawingData.colorData;
        
        if (!isMask)
            renderer.draw(texture, drawMatrix, color, drawingData.blendMode);
		
		if (!isMask)
		{
			var transformedDrawingX:Float = drawingBoundsX * textureScaleX;
			var transformedDrawingY:Float = drawingBoundsY * textureScaleY;
			var transformedDrawingWidth:Float = (drawingBoundsWidth * 2 * textureScaleX) / 2;
			var transformedDrawingHeight:Float = (drawingBoundsHeight * 2 * textureScaleY) / 2;
			
			if (!hitTestResult && checkMouseHit) 
			{
				drawMatrix.invert();
				GeomMath.transformPoint(drawMatrix, mousePoint.x, mousePoint.y, false, transformedMousePoint);
				
				hitTestResult = hitTest(true, texture, transformedDrawingX, transformedDrawingY, transformedDrawingWidth, transformedDrawingHeight, transformedMousePoint);
			}
			
			if (checkBounds)
			{
				if (isDebugDraw) 
					drawingRectagon.setTo(transformedDrawingX, transformedDrawingY, transformedDrawingWidth, transformedDrawingHeight);
					
				currentBoundForDraw.setTo(drawingRectagon.x, drawingRectagon.y, drawingRectagon.width, drawingRectagon.height);
				GeomMath.rectangleUnion(drawingData.bound, currentBoundForDraw);
			}
		}
    }
}
