package gl;

import gl.drawer.GLDisplayListDrawer;
import openfl.display.Stage;
import openfl.display3D.Context3D;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import renderer.ProjectionMatrix;
import renderer.Renderer;
import swfdata.ColorData;
import swfdata.DisplayObjectContainer;
import swfdata.atlas.TextureStorage;
import utils.DisplayObjectUtils;

class GlStage extends DisplayObjectContainer
{
	var viewPortBuffer:Rectangle = new Rectangle(0, 0, 0, 0);
	
	var drawingMatrix:Matrix = new Matrix();
	var drawingColor:ColorData = new ColorData();
	var mouseData:MouseData;
	var drawingBound:Rectangle = new Rectangle();
	var drawer:GLDisplayListDrawer;
	public var renderer:Renderer;
	
	public var stage:Stage;
	
	var handleMouse:Bool = false;
	var clickPosition:Point = new Point();
	public var textureStorage:TextureStorage;
	
	public function new(stage:Stage, context3D:Context3D, textureStorage:TextureStorage) 
	{
		super();
		this.textureStorage = textureStorage;
		
		this.stage = stage;
		
		mouseData = new MouseData();
		renderer = new Renderer(context3D, textureStorage);
		@:privateAccess renderer.projection = ProjectionMatrix.getOrtho(stage.stageWidth, stage.stageHeight, null);
		
		drawer = new GLDisplayListDrawer(textureStorage, mouseData.mousePosition);
		drawer.target = renderer;
		
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightDown);
		stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightUp);
		stage.addEventListener(Event.RESIZE, onResize);
	}
	
	private function onResize(e:Event):Void
    {
        @:privateAccess renderer.isViewportUpdated = true;
        @:privateAccess renderer.projection = ProjectionMatrix.getOrtho(stage.stageWidth, stage.stageHeight, null);
    }

	private function onRightDown(e:MouseEvent):Void
	{
		mouseData.isRightDown = true;
		e.stopImmediatePropagation();
		e.preventDefault();
	}
	
	private function onRightUp(e:MouseEvent):Void 
	{
		mouseData.isRightDown = false;
	}
	
	private function onMouseUp(e:MouseEvent):Void 
	{
		mouseData.isLeftDown = false;
		handleMouse = false;
		mouseData.mouseMove.setTo(0, 0);
	}
	
	private function onMouseDown(e:MouseEvent):Void 
	{
		mouseData.isLeftDown = true;
		handleMouse = true;
		clickPosition.setTo(stage.mouseX, stage.mouseY);
	}
	
	private function onMouseMove():Void 
	{
		mouseData.mousePosition.setTo(stage.mouseX, stage.mouseY);
		mouseData.mouseMove.setTo(stage.mouseX - clickPosition.x, stage.mouseY - clickPosition.y);
			
		clickPosition.setTo(stage.mouseX, stage.mouseY);
	}
	
	override public function update():Void
	{
		var isCheckDrawingBounds:Bool = false;
		
		if (handleMouse)
			onMouseMove();
			
		for (i in 0...displayObjectsPlacedCount)
		{
           var updatable = DisplayObjectUtils.asUpdatable(_displayObjects[i]);
		   
		   if (updatable != null)
				updatable.update();
        }
		
		renderer.begin();
		
		drawer.checkMouseHit = mouseData.isLeftDown;
		drawingBound.setTo(0, 0, 0, 0);
		
		for (spriteData in _displayObjects)
		{
			var drawingBound:Rectangle = spriteData.bounds;
			
			isCheckDrawingBounds = drawingBound.width == 0 && drawingBound.height == 0;
			
			if (!isCheckDrawingBounds && drawingBound.intersects(viewPortBuffer)) {
				//trace('not on view');
				continue;
			}
			if (!spriteData.visible) {
				//trace('sprite is invisible');
				continue;
			}
			
			if (isCheckDrawingBounds)
			{
				drawingBound.setTo(0, 0, 0, 0);
				drawer.checkBounds = true;
			}
			else
				drawer.checkBounds = false;
				
			drawingColor.clear();
			drawingMatrix.identity();
			drawer.drawDisplayObject(spriteData, drawingMatrix, drawingBound, drawingColor);
			
			if (drawer.isHitMouse == true && spriteData.isUnderMouse == false)
			{
				//if(mouseData.isRightDown)
				//	currentActor.onRightMouseDown();
				//else
				//if (mouseData.isLeftDown)
				//	trace('mouseDown ${@:privateAccess drawer.drawingData.hitTarget}');
					
					@:privateAccess drawer.drawingData.hitTarget.setColorData(3, 1, 1, 1, 0, 0, 0, 0);
					//spriteData.onMouseDown();
			}
			
			if (drawer.isHitMouse == false && spriteData.isUnderMouse == true)
			{
				trace('moueUp');
				@:privateAccess drawer.drawingData.hitTarget.setColorData(1, 1, 1, 1, 0, 0, 0, 0);
				//spriteData.onMouseUp();
				//currentActor.onRightMouseUp();
			}
			
			spriteData.isUnderMouse = drawer.isHitMouse;
		}
		
		renderer.render();
		renderer.end();
	}
}