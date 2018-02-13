package swfdrawer;

import flash.errors.Error;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;
import genome.drawer.GenomeDrawer;
import genome.drawer.GenomeShapeDrawer;
import swfdata.atlas.BaseTextureAtlas;
import swfdata.atlas.genome.GenomeTextureAtlas;
import swfdata.ColorData;
import swfdata.DisplayObjectData;
import swfdata.DisplayObjectTypes;
import swfdata.MovieClipData;
import swfdata.ShapeData;
import swfdata.SpriteData;
import swfdata.SwfdataInner;
import swfdrawer.data.DrawingData;

class DisplayListDrawer implements IDrawer
{
    public var atlas(never, set) : BaseTextureAtlas;
    public var checkBounds(never, set) : Bool;
    public var checkMouseHit(never, set) : Bool;
    public var debugDraw(never, set) : Bool;
    public var isHitMouse(get, never) : Bool;
    public var hightlight(never, set) : Bool;
    public var grassWind(get, set) : Bool;
    public var debugConvas(never, set) : Graphics;
    public var smooth(never, set) : Bool;

    private var drawersMap : Dictionary = new Dictionary();
    private var mousePoint : Point;
    private var shapeDrawer : GenomeShapeDrawer;
    
    private var drawingData : DrawingData = new DrawingData();
    
    private var _atlas : BaseTextureAtlas;
    
    public function new(atlas : BaseTextureAtlas, mousePoint : Point)
    {
        this.mousePoint = mousePoint;
        
        _atlas = atlas;
        initialize();
    }
    
    private function set_atlas(atlas : BaseTextureAtlas) : BaseTextureAtlas
    {
        _atlas = atlas;
        shapeDrawer.atlas = atlas;
        return atlas;
    }
    
    /**
		 * Define is drawer should calculate full bound of object - Union of bound for every child
		 */
    private function set_checkBounds(value : Bool) : Bool
    {
        shapeDrawer.checkBounds = value;
        return value;
    }
    
    /**
		 * Define is drawer should do mouse hit test
		 * 
		 */
    private function set_checkMouseHit(value : Bool) : Bool
    {
        shapeDrawer.checkMouseHit = value;
        return value;
    }
    
    /**
		 * Define is drawer should draw debug data
		 */
    private function set_debugDraw(value : Bool) : Bool
    {
        shapeDrawer.isDebugDraw = value;
        return value;
    }
    
    private function get_isHitMouse() : Bool
    {
        return shapeDrawer.hitTestResult;
    }
    
    private function initialize() : Void
    {
        shapeDrawer = new GenomeShapeDrawer(_atlas, mousePoint);
        
        var spriteDrawer : SpriteDrawer = new SpriteDrawer(this);
        var movieClipDrawer : MovieClipDrawer = new MovieClipDrawer(this);
        
        drawersMap[DisplayObjectTypes.SHAPE_TYPE] = shapeDrawer;
        drawersMap[DisplayObjectTypes.SPRITE_TYPE] = spriteDrawer;
        drawersMap[DisplayObjectTypes.MOVIE_CLIP_TYPE] = movieClipDrawer;
    }
    
    public function clear() : Void
    {
        shapeDrawer.clearMouseHitStatus();
        drawingData.clear();
    }
    
    public function drawDisplayObject(displayObject : DisplayObjectData, transform : Matrix, bound : Rectangle = null, colorData : ColorData = null) : Void
    {
        clear();
        
        drawingData.transform = transform;
        drawingData.bound = bound;
        
        if (colorData != null)
        {
            drawingData.colorData.concat(colorData);
        }
        else if (displayObject.colorData)
        {
            drawingData.colorData.concat(displayObject.colorData);
        }
        
        draw(displayObject, drawingData);
    }
    
    public function draw(displayObject : DisplayObjectData, drawingData : DrawingData) : Void
    {
        var type : Int = displayObject.displayObjectType;
        
        var drawer : IDrawer = drawersMap[type];
        
        if (drawer != null)
        {
            drawer.draw(displayObject, drawingData);
        }
        else
        {
            throw new Error("drawer for " + displayObject + " is not defined");
        }
    }
    
    public function setHightlightColor(value : Int, alpha : Float) : Void
    {
        var r : Float = (as3hx.Compat.parseInt(value >> 16) & 0xFF) / 0xFF;
        var g : Float = (as3hx.Compat.parseInt(value >> 8) & 0xFF) / 0xFF;
        var b : Float = (value & 0xFF) / 0xFF;
    }
    
    private function set_hightlight(value : Bool) : Bool
    {
        shapeDrawer.hightlight = value;
        return value;
    }
    
    //TODO: Вынести такие штуки в парамтеры фильтров в DisplayObject
    private function set_grassWind(value : Bool) : Bool
    {
        shapeDrawer.isUseGrassWind = value;
        return value;
    }
    
    private function get_grassWind() : Bool
    {
        return shapeDrawer.isUseGrassWind;
    }
    
    /**
		 * Задает таргет для отрисовки дебаг даты
		 */
    private function set_debugConvas(value : Graphics) : Graphics
    {
        shapeDrawer.convas = value;
        return value;
    }
    
    //Фильтринг linear, nearest
    private function set_smooth(value : Bool) : Bool
    {
        shapeDrawer.smooth = value;
        return value;
    }
}
