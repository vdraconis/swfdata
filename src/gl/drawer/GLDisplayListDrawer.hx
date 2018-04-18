package gl.drawer;

import openfl.display.Graphics;
import openfl.errors.Error;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.Dictionary;
import gl.drawer.GLShapeDrawer;
import renderer.Renderer;
import swfdata.ColorData;
import swfdata.DisplayObjectData;
import swfdata.DisplayObjectTypes;
import swfdata.atlas.ITextureAtlas;
import swfdata.atlas.TextureStorage;
import swfdrawer.IDrawer;
import swfdrawer.MovieClipDrawer;
import swfdrawer.SpriteDrawer;
import swfdrawer.data.DrawingData;

class GLDisplayListDrawer implements IDrawer
{
    public var checkBounds(never, set):Bool;
    public var checkMouseHit(never, set):Bool;
    public var debugDraw(never, set):Bool;
    public var isHitMouse(get, never):Bool;
    public var hightlightSize(get, set):Int;
    public var debugConvas(never, set):Graphics;
    public var smooth(never, set):Bool;
	
	@:isVar public var target(get, set):Renderer;

    var drawersMap:Map<Int, IDrawer> = new Map<Int, IDrawer>();
    var mousePoint:Point;
    var shapeDrawer:GLShapeDrawer;
    
    var drawingData:DrawingData = new DrawingData();
    
    var textureStorage:TextureStorage;
    
    public function new(textureStorage:TextureStorage, mousePoint:Point = null)
    {
        this.mousePoint = mousePoint;
        
        this.textureStorage = textureStorage;
        initialize();
    }
    
    /**
	 * Define is drawer should calculate full bound of object - Union of bound for every child
	 */
    function set_checkBounds(value:Bool):Bool
    {
        shapeDrawer.drawerOptions.isCheckBounds = value;
        return value;
    }
    
    /**
	 * Define is drawer should do mouse hit test
	 * 
	 */
    function set_checkMouseHit(value:Bool):Bool
    {
        shapeDrawer.drawerOptions.isCheckMouseHit = value;
        return value;
    }
    
    /**
	 * Define is drawer should draw debug data
	 */
    function set_debugDraw(value:Bool):Bool
    {
        shapeDrawer.drawerOptions.isDebugDraw = value;
        return value;
    }
    
    function get_isHitMouse():Bool
    {
        return drawingData.hitTestResult;
    }
    
    function initialize():Void
    {
        shapeDrawer = new GLShapeDrawer(textureStorage, mousePoint);
        
        var spriteDrawer:SpriteDrawer = new SpriteDrawer(this);
        var movieClipDrawer:MovieClipDrawer = new MovieClipDrawer(this);
        
        drawersMap[DisplayObjectTypes.SHAPE_TYPE] = shapeDrawer;
        drawersMap[DisplayObjectTypes.SPRITE_TYPE] = spriteDrawer;
        drawersMap[DisplayObjectTypes.MOVIE_CLIP_TYPE] = movieClipDrawer;
    }
    
    public function clear():Void
    {
        shapeDrawer.clearMouseHitStatus();
        drawingData.clear();
    }
    
	@:access(swfdata)
    public function drawDisplayObject(displayObject:DisplayObjectData, transform:Matrix, bound:Rectangle = null, colorData:ColorData = null):Void
    {
        clear();
        
        drawingData.transform = transform;
        drawingData.bound = bound;
        
        if (colorData != null)
        {
            drawingData.colorData.preMultiply(colorData);
        }
        else if (displayObject.colorData != null)
        {
            drawingData.colorData.preMultiply(displayObject.colorData);
        }
        
        draw(displayObject, drawingData);
    }
    
	@:access(swfdata)
    public function draw(displayObject:DisplayObjectData, drawingData:DrawingData):Void
    {
        var type:Int = displayObject.displayObjectType;
        
        var drawer:IDrawer = drawersMap[type];
        
        if (drawer != null) 
            drawer.draw(displayObject, drawingData)
        else
		{
			#if debug
			throw new Error("drawer for " + displayObject + " is not defined");
			#else
			trace("drawer for " + displayObject + " is not defined");
			#end
		}
    }
    
    public function setHightlightColor(value:Int, alpha:Float):Void
    {
        var r:Float = ((value >> 16) & 0xFF) / 0xFF;
        var g:Float = ((value >> 8) & 0xFF) / 0xFF;
        var b:Float = (value & 0xFF) / 0xFF;
        
        //shapeDrawer.outline.red = r;
        //shapeDrawer.outline.green = g;
        //shapeDrawer.outline.blue = b;
        //shapeDrawer.outline.alpha = alpha;
    }
    
    function get_hightlightSize():Int
    {
        return 0;// shapeDrawer.outline.size;
    }

    function set_hightlightSize(value:Int):Int
    {
        //shapeDrawer.outline.size = value;
        return value;
    }
    
    /**
	 * Задает таргет для отрисовки дебаг даты
	 */
    function set_debugConvas(value:Graphics):Graphics
    {
        //shapeDrawer.convas = value;
        return value;
    }
    
    //Фильтринг linear, nearest
    function set_smooth(value:Bool):Bool
    {
        shapeDrawer.drawerOptions.smooth = value;
        return value;
    }
	
	function get_target():Renderer 
	{
		return target;
	}
	
	function set_target(value:Renderer):Renderer 
	{
		shapeDrawer.renderer = value;
		return target = value;
	}
}