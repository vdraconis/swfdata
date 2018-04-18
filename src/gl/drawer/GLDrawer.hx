package gl.drawer;

import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import renderer.Renderer;
import swfdata.DisplayObjectData;
import swfdata.Rectagon;
import swfdata.atlas.GLSubTexture;
import swfdata.atlas.TextureStorage;
import swfdata.atlas.TextureTransform;
import swfdrawer.IDrawer;
import swfdrawer.data.DrawingData;

class GLDrawer implements IDrawer
{
	public var renderer:Renderer;
	public var drawerOptions:DrawerOptions = new DrawerOptions();
	
    var drawMatrix:Matrix = new Matrix();
    
    var currentBoundForDraw:Rectangle = new Rectangle();
    var drawingRectagon:Rectagon;
    
    var textureId:Int;
    var currentTeture:GLSubTexture;
    
    var mousePoint:Point;
    var transformedMousePoint:Point = new Point();
    
    var texturePadding:Float;
    var texturePadding2:Float;
    
    var textureStorage:TextureStorage;
    
    var drawingData:DrawingData;
	var drawable:DisplayObjectData;
	
    public function new(mousePoint:Point)
    {
        this.mousePoint = mousePoint;
        drawingRectagon = new swfdata.Rectagon(0, 0, 0, 0, drawMatrix);
    }
    
    inline public function clearMouseHitStatus():Void
    {
		if(drawingData != null)
			drawingData.hitTestResult = false;
    }
    
	@:access(swfdata) inline public function applyDrawStyle():Void
    {
        currentTeture = Lang.as2(textureStorage.getGexture(textureId), GLSubTexture);
        
        var transform:TextureTransform = currentTeture.transform;
        var mulX:Float = transform.positionMultiplierX;
        var mulY:Float = transform.positionMultiplierY;
        
		var drawMatrix = this.drawMatrix;
        drawMatrix.a *= mulX;
        drawMatrix.d *= mulY;
        drawMatrix.b *= mulX;
        drawMatrix.c *= mulY;
		
        this.texturePadding2 = currentTeture.padding * 2;
    }
    
    public function draw(drawable:DisplayObjectData, drawingData:DrawingData):Void
    {
        this.drawable = drawable;
		this.drawingData = drawingData;
        this.drawingData.setFromDisplayObject(drawable);
        this.textureId = drawable.characterId;
    }
    
	inline public function hitTest(pixelPerfect:Bool, texture:GLSubTexture, transformedDrawingX:Float, transformedDrawingY:Float, transformedDrawingWidth:Float, transformedDrawingHeight:Float, transformedPoint:Point)
    {
		var isHit:Bool = false;
		
        if (transformedPoint.x > transformedDrawingX && transformedPoint.x < transformedDrawingX + transformedDrawingWidth) 
		{
            if (transformedPoint.y > transformedDrawingY && transformedPoint.y < transformedDrawingY + transformedDrawingHeight) 
			{
				if (pixelPerfect) 
				{
					var u:Float = (transformedPoint.x - transformedDrawingX) / (transformedDrawingWidth + texturePadding2);
					var v:Float = (transformedPoint.y - transformedDrawingY) / (transformedDrawingHeight + texturePadding2);
					
					isHit = texture.getAlphaAtUV(u, v) > 0x05;
				}
				else
					isHit = true;
			}
		}
		
		setHitData(isHit);
    }
	
	inline public function setHitData(isHit:Bool)
	{
		drawingData.hitTestResult = isHit;
		
		if(isHit)
			drawingData.hitTarget = drawable;
	}
    
	@:access(swfdata) public function drawRectangle(drawingBounds:Rectangle, transform:Matrix):Void
    {
        drawMatrix.identity();
		
        drawMatrix.concat(transform);

        applyDrawStyle();
        
        var texture:GLSubTexture = currentTeture;
        var textureTransform:TextureTransform = texture.transform;
		
		var textureScaleX = textureTransform.scaleX;
		var textureScaleY = textureTransform.scaleY;
		
		var drawingBoundsX = drawingBounds.x;
		var drawingBoundsY = drawingBounds.y;
		var drawingBoundsWidth = drawingBounds.width;
		var drawingBoundsHeight = drawingBounds.height;
        
        texture.pivotX = -(drawingBoundsX * textureScaleX + (texture.width - texturePadding2) / 2);
        texture.pivotY = -(drawingBoundsY * textureScaleY + (texture.height - texturePadding2) / 2);
		
        var isNotMask:Bool = !drawingData.isMask;
        
        if (isNotMask)
            renderer.draw(texture, drawMatrix, drawingData);
		
		if (isNotMask)
		{
			var transformedDrawingX:Float = drawingBoundsX * textureScaleX;
			var transformedDrawingY:Float = drawingBoundsY * textureScaleY;
			var transformedDrawingWidth:Float = (drawingBoundsWidth * 2 * textureScaleX) / 2;
			var transformedDrawingHeight:Float = (drawingBoundsHeight * 2 * textureScaleY) / 2;
			
			if (!drawingData.hitTestResult && drawerOptions.isCheckMouseHit) 
			{
				drawMatrix.invert();
				GeomMath.transformPoint(drawMatrix, mousePoint.x, mousePoint.y, false, transformedMousePoint);
				
				hitTest(true, texture, transformedDrawingX, transformedDrawingY, transformedDrawingWidth, transformedDrawingHeight, transformedMousePoint);
			}
			
			if (drawerOptions.isCheckBounds)
			{
				if (drawerOptions.isDebugDraw) 
					drawingRectagon.setTo(transformedDrawingX, transformedDrawingY, transformedDrawingWidth, transformedDrawingHeight);
					
				currentBoundForDraw.setTo(drawingRectagon.x, drawingRectagon.y, drawingRectagon.width, drawingRectagon.height);
				GeomMath.rectangleUnion(drawingData.bound, currentBoundForDraw);
			}
		}
    }
}
