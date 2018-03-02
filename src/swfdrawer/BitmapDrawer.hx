package swfdrawer;

import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import swfdata.ColorData;
import swfdata.DisplayObjectData;
import swfdata.Rectagon;
import swfdata.atlas.BitmapSubTexture;
import swfdata.atlas.BitmapTextureAtlas;
import swfdata.atlas.TextureTransform;
import swfdrawer.data.DrawingData;

class BitmapDrawer implements IDrawer
{
	var mousePoint:Point;
	var textureAtlas:BitmapTextureAtlas;
	
	var drawMatrix:Matrix = new Matrix();
	var currentSubTexture:BitmapSubTexture;
	var drawingData:DrawingData;
	var textureId:Int;
	var texturePadding2:Float;
	var drawingRectagon:Rectagon;
	var alphaPoint:Point = new Point();
	var clipRect:Rectangle = new Rectangle();
	var currentBoundForDraw:Rectangle = new Rectangle();
	
	public var target:BitmapData;
	public var canvas:Graphics;
	
	public var smooth:Bool;
	public var hitTestResult:Bool;
	public var isDebugDraw:Bool;
	public var checkMouseHit:Bool;
	public var checkBounds:Bool;
	
	public function new(mousePoint:Point)
	{
		this.mousePoint = mousePoint;
		drawingRectagon = new Rectagon(0, 0, 0, 0, drawMatrix);
	}
	
	public function clearMouseHitStatus() 
	{
		hitTestResult = false;
	}
	
	public function draw(drawable:DisplayObjectData, drawingData:DrawingData):Void 
	{
		this.drawingData = drawingData;
        
        drawingData.setFromDisplayObject(drawable);
        textureId = drawable.characterId;
        this.texturePadding2 = textureAtlas.padding * 2;
	}
	
	@:access(swfdata)
	function applyDrawStyle():Void
	{
		currentSubTexture = Lang.as(textureAtlas.getTexture(textureId), BitmapSubTexture);
        
        var transform:TextureTransform = currentSubTexture._transform;
        var mulX:Float = transform.positionMultiplierX;
        var mulY:Float = transform.positionMultiplierY;
        
        drawMatrix.a *= mulX;
        drawMatrix.d *= mulY;
        drawMatrix.b *= mulX;
        drawMatrix.c *= mulY;
	}
	
	function cleanDrawStyle():Void
	{
		textureId = -1;
        currentSubTexture = null;
	}
	
	public static function transformPoint(matrix:Matrix, x:Float, y:Float, noDelta:Bool = false, result:Point = null):Point {
		
		var dx:Float = noDelta ? 0:matrix.tx;
		var dy:Float = noDelta ? 0:matrix.ty;
		result.x = matrix.a * x + matrix.c * y + dx;
		result.y = matrix.d * y + matrix.b * x + dy;
		return result;
	}
	
	@:access(swfdata)
	function drawRectangle(drawingBounds:Rectangle, transform:Matrix) 
	{
		drawMatrix.identity();
        drawMatrix.concat(transform);
		
		applyDrawStyle();
		
		var texture:BitmapSubTexture = currentSubTexture;
        var textureTransform:TextureTransform = currentSubTexture._transform;
		
		
		drawingRectagon.setTo(drawingBounds.x, drawingBounds.y, drawingBounds.width, drawingBounds.height);
        
      
		
		//texture.g2d_pivotX = -(drawingBounds.x * textureTransform.scaleX + (texture.width - texturePadding2) / 2);
        //texture.g2d_pivotY = -(drawingBounds.y * textureTransform.scaleY + (texture.height - texturePadding2) / 2);
        
        var color:ColorData = drawingData.colorData;
		
		
		drawMatrix.tx -= texture.bounds.x;
		drawMatrix.ty -= texture.bounds.y;

		//trace(texture.bounds.x, texture.bounds.y);
		
		clipRect.setTo(drawingRectagon.resultTopLeft.x, drawingRectagon.resultTopLeft.y, drawingRectagon.width, drawingRectagon.height);
		
		
		
		target.draw(textureAtlas.atlasData, drawMatrix, null, null, clipRect, smooth);
		
		var transformedDrawingX:Float = drawingBounds.x * currentSubTexture.transform.scaleX;
        var transformedDrawingY:Float = drawingBounds.y * currentSubTexture.transform.scaleY;
        var transformedDrawingWidth:Float = (drawingBounds.width * 2 * currentSubTexture.transform.scaleX) / 2;
        var transformedDrawingHeight:Float = (drawingBounds.height * 2 * currentSubTexture.transform.scaleY) / 2;
        
        if (checkBounds) 
            drawingRectagon.setTo(transformedDrawingX, transformedDrawingY, transformedDrawingWidth, transformedDrawingHeight);
        
        if (checkBounds) 
        {
            currentBoundForDraw.setTo(drawingRectagon.x, drawingRectagon.y, drawingRectagon.width, drawingRectagon.height);
            GeomMath.rectangleUnion(drawingData.bound, currentBoundForDraw);
        }
		
		//Genome2D.g2d_instance.g2d_context.drawMatrix(texture, drawMatrix.a, drawMatrix.b, drawMatrix.c, drawMatrix.d, transform.tx, transform.ty, color.r, color.g, color.b, color.a);
	}
}