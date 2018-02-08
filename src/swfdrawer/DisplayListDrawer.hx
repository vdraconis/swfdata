package swfdrawer;

import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.errors.Error;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import swfdata.ColorData;
import swfdata.DisplayObjectData;
import swfdata.DisplayObjectTypes;
import swfdata.atlas.ITextureAtlas;
import swfdrawer.IDrawer;
import swfdrawer.MovieClipDrawer;
import swfdrawer.ShapeDrawer;
import swfdrawer.SpriteDrawer;
import swfdrawer.data.DrawingData;

class DisplayListDrawer implements IDrawer
{
    public var atlas(never, set):ITextureAtlas;
    public var checkBounds(never, set):Bool;
    public var checkMouseHit(never, set):Bool;
    public var debugDraw(never, set):Bool;
    public var isHitMouse(get, never):Bool;
    public var hightlight(never, set):Bool;
    public var grassWind(get, set):Bool;
    public var debugCanvas(never, set):Graphics;
    public var smooth(never, set):Bool;
	public var target(get, set):BitmapData;

    var drawersMap:Map<Int, IDrawer> = new Map<Int, IDrawer>();
    var mousePoint:Point;
    var shapeDrawer:ShapeDrawer;
    
    var drawingData:DrawingData = new DrawingData();
    
    var _atlas:ITextureAtlas;
    
    public function new(atlas:ITextureAtlas, mousePoint:Point)
    {
        this.mousePoint = mousePoint;
        
        _atlas = atlas;
        initialize();
    }
    
    private function set_atlas(atlas:ITextureAtlas):ITextureAtlas
    {
        _atlas = atlas;
        shapeDrawer.atlas = atlas;
        return atlas;
    }
    
    /**
		 * Define is drawer should calculate full bound of object - Union of bound for every child
		 */
    private function set_checkBounds(value:Bool):Bool
    {
        shapeDrawer.checkBounds = value;
        return value;
    }
    
    /**
		 * Define is drawer should do mouse hit test
		 * 
		 */
    private function set_checkMouseHit(value:Bool):Bool
    {
        shapeDrawer.checkMouseHit = value;
        return value;
    }
    
    /**
		 * Define is drawer should draw debug data
		 */
    private function set_debugDraw(value:Bool):Bool
    {
        shapeDrawer.isDebugDraw = value;
        return value;
    }
    
    private function get_isHitMouse():Bool
    {
        return shapeDrawer.hitTestResult;
    }
    
    private function initialize():Void
    {
        shapeDrawer = new ShapeDrawer(_atlas, mousePoint);
        
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
            drawingData.colorData.mulColorData(colorData)
        else if (displayObject.colorData != null) 
            drawingData.colorData.mulColorData(displayObject.colorData);
        
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
        throw new Error("drawer for " + displayObject + " is not defined");
    }
    
    public function setHightlightColor(value:Int, alpha:Float):Void
    {
        var r:Float = ((value >> 16) & 0xFF) / 0xFF;
        var g:Float = ((value >> 8) & 0xFF) / 0xFF;
        var b:Float = (value & 0xFF) / 0xFF;
        
        //GenomeDrawer.outline.red = r;
		//GenomeDrawer.outline.green = g;
        //GenomeDrawer.outline.blue = b;
        //GenomeDrawer.outline.alpha = alpha;
        //GenomeDrawer.outline.size = 2.5;
    }
    
    private function set_hightlight(value:Bool):Bool
    {
        //shapeDrawer.hightlight = value;
        return value;
    }
    
    //TODO: Вынести такие штуки в парамтеры фильтров в DisplayObject
    private function set_grassWind(value:Bool):Bool
    {
        //shapeDrawer.isUseGrassWind = value;
        return value;
    }
    
    private function get_grassWind():Bool
    {
        return false;// shapeDrawer.isUseGrassWind;
    }
    
    /**
	 * Задает таргет для отрисовки дебаг даты
	 */
    private function set_debugCanvas(value:Graphics):Graphics
    {
        shapeDrawer.canvas = value;
        return value;
    }
    
    //Фильтринг linear, nearest
    private function set_smooth(value:Bool):Bool
    {
        shapeDrawer.smooth = value;
        return value;
    }
	
	function get_target():BitmapData 
	{
		return shapeDrawer.target;
	}
	
	function set_target(value:BitmapData):BitmapData 
	{
		shapeDrawer.target = value;
		return value;
	}
}