package swfdrawer;

import openfl.display.Graphics;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import swfdata.Rectagon;
import swfdata.atlas.BitmapSubTexture;
import swfdata.atlas.BitmapTextureAtlas;
import swfdata.atlas.ITextureAtlas;
import swfdata.atlas.TextureTransform;
import swfdrawer.data.DrawingData;

import openfl.geom.Point;
import swfdata.DisplayObjectData;

class GraphicsDrawer implements IDrawer
{
	var mousePoint:Point;
	var textureAtlas:BitmapTextureAtlas;
	
	@:allow(GraphicsDrawer)
	var drawMatrix:Matrix = new Matrix();
	var currentSubTexture:BitmapSubTexture;
	var drawingData:DrawingData;
	var textureId:Int;
	var texturePadding2:Float;
	var drawingRectagon:Rectagon;
	var alphaPoint:Point = new Point();
	
	
	public var target:Graphics;
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
		currentSubTexture = cast textureAtlas.getTexture(textureId);
        
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
		
		drawingRectagon.setTo(drawingBounds.x, drawingBounds.y, drawingBounds.width, drawingBounds.height);
        
        var texture:BitmapSubTexture = currentSubTexture;
        
        var textureTransform:TextureTransform = currentSubTexture._transform;
		
		transformPoint(drawMatrix, texture.bounds.x, texture.bounds.y, true, alphaPoint);
		
		drawMatrix.tx = drawingRectagon.resultTopLeft.x - alphaPoint.x;
		drawMatrix.ty = drawingRectagon.resultTopLeft.y - alphaPoint.y;
		
		//trace(alphaPoint);
		
		target.beginBitmapFill(textureAtlas.atlasData, drawMatrix, false, smooth);
		//target.beginFill(0xFFFFFF, 0.5);
		
		target.moveTo(drawingRectagon.resultTopLeft.x, drawingRectagon.resultTopLeft.y);
		target.lineTo(drawingRectagon.resultTopRight.x, drawingRectagon.resultTopRight.y);
		target.lineTo(drawingRectagon.resultBottomRight.x, drawingRectagon.resultBottomRight.y);
		target.lineTo(drawingRectagon.resultBottomLeft.x, drawingRectagon.resultBottomLeft.y);
		target.lineTo(drawingRectagon.resultTopLeft.x, drawingRectagon.resultTopLeft.y);
		
		
		//trace('draw', drawingRectagon.resultTopLeft, drawingRectagon.resultBottomRight);
		
		target.endFill();
	}
}