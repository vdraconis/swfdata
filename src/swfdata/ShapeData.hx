package swfdata;

import openfl.geom.Rectangle;
import swfdata.DisplayObjectData;
import utils.DisplayObjectUtils;

using swfdata.ShapeData;

class ShapeData extends DisplayObjectData
{
    public var shapeBounds(get, set):Rectangle;

    public var tx:Float;
    public var ty:Float;
	
	public var width(get, set):Float;
	public var height(get, set):Float;
    
	@:allow(swfdata)
    private var _shapeBounds:Rectangle;
    
    public var normalized:Bool;
    
    public var usedCount:Int = 0;
    
    public function new(characterId:Int = -1, shapeBounds:Rectangle = null)
    {
        super(characterId, DisplayObjectTypes.SHAPE_TYPE);
        
        _shapeBounds = shapeBounds;
    }
    
    override public function destroy():Void
    {
        super.destroy();
        _shapeBounds = null;
    }
    
    //public function normalizeBounds():void
    //{
    //	return
    //	normalized = true;
    //
    //	transform.tx += tx;
    //	transform.ty += ty;
    //
    //	bounds.applyTransform();
    //}
    
    public function resetBound():Void
    {
        //bounds.setTo(_shapeBounds.x, _shapeBounds.y, _shapeBounds.width, _shapeBounds.height);
    }
    
    private function get_shapeBounds():Rectangle
    {
        return _shapeBounds;
    }
    
    private function set_shapeBounds(value:Rectangle):Rectangle
    {
        _shapeBounds = value;
        return value;
    }
    
	inline public static function setDataFrom(to:ShapeData, from:ShapeData):Void
    {
        DisplayObjectData.setDataFrom(to, from);
        
        to.shapeBounds = from._shapeBounds;
        
        to.tx = from.tx;
        to.ty = from.ty;
    }
	
	
	override public function softClone():DisplayObjectData 
	{
		var objectCloned:ShapeData = new ShapeData();
        ShapeData.setDataFrom(objectCloned, this);
        
        return objectCloned;
	}
    
    override public function clone():DisplayObjectData
    {
        return super.clone();
    }
	
	override function get_x():Float 
	{
		return _shapeBounds.x;
	}
	
	override function set_x(value:Float):Float 
	{
		return _shapeBounds.x = value;
	}
	
	override function get_y():Float 
	{
		return _shapeBounds.y;
	}
	
	override function set_y(value:Float):Float 
	{
		return _shapeBounds.y = value;
	}
	
	function get_height():Float 
	{
		return _shapeBounds.height;
	}
	
	function set_height(value:Float):Float 
	{
		return _shapeBounds.height = value;
	}
	
	function get_width():Float 
	{
		return _shapeBounds.width;
	}
	
	function set_width(value:Float):Float 
	{
		return _shapeBounds.width = value;
	}
}