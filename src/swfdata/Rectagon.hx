package swfdata;


import flash.display.Graphics;
import flash.geom.Matrix;
import flash.geom.Point;

class Rectagon
{
    public var transform(get, set) : Matrix;

    public var x : Float;
    public var y : Float;
    public var width : Float;
    public var height : Float;
    
    public var localX : Float;
    public var localY : Float;
    public var localWidth : Float;
    public var localHeight : Float;
    
    public var topLeft : Point = new Point();
    public var topRight : Point = new Point();
    public var bottomLeft : Point = new Point();
    public var bottomRight : Point = new Point();
    
    public var resultTopLeft : Point = new Point();
    public var resultTopRight : Point = new Point();
    public var resultBottomLeft : Point = new Point();
    public var resultBottomRight : Point = new Point();
    
    private var _transform : Matrix;
    
    public function new(x : Float, y : Float, width : Float, height : Float, transform : Matrix)
    {
        this._transform = transform;
        
        localX = x;
        localY = y;
        localWidth = width;
        localHeight = height;
        
        topLeft.setTo(x, y);
        topRight.setTo(x + width, y);
        bottomLeft.setTo(x, y + height);
        bottomRight.setTo(x + width, y + height);
    }
    
    @:meta(Inline())

    public static function transformX(px : Float, py : Float, transform : Matrix) : Float
    {
        return px * transform.a + py * transform.c + transform.tx;
    }
    
    @:meta(Inline())

    public static function transformY(px : Float, py : Float, transform : Matrix) : Float
    {
        return px * transform.b + py * transform.d + transform.ty;
    }
    
    public function union(rectagon : Rectagon) : Void
    {
        if (_transform == rectagon._transform) 
            _transform = _transform.clone();
        
        _transform.concat(rectagon._transform);
        
        localX = Math.min(localX, rectagon.localX);
        localY = Math.min(localY, rectagon.localY);
        localWidth = Math.max(localWidth, localWidth) - localX;
        localHeight = Math.max(localHeight, localHeight) - localY;
        
        setTo(localX, localY, localWidth, localHeight);
    }
    
    public function clear() : Void
    {
        localX = 0;
        localY = 0;
        localWidth = 0;
        localHeight = 0;
        
        topLeft.setTo(0, 0);
        topRight.setTo(0, 0);
        bottomLeft.setTo(0, 0);
        bottomRight.setTo(0, 0);
    }
    
    public function setToWithTransform(x : Float, y : Float, width : Float, height : Float, transform : Matrix) : Void
    {
        localX = x;
        localY = y;
        localWidth = width;
        localHeight = height;
        
        topLeft.setTo(x, y);
        topRight.setTo(x + width, y);
        bottomLeft.setTo(x, y + height);
        bottomRight.setTo(x + width, y + height);
        
        _transform = transform;
        
        applyTransform();
    }
    
    public function setTo(x : Float, y : Float, width : Float, height : Float) : Void
    {
        localX = x;
        localY = y;
        localWidth = width;
        localHeight = height;
        
        topLeft.setTo(x, y);
        topRight.setTo(x + width, y);
        bottomLeft.setTo(x, y + height);
        bottomRight.setTo(x + width, y + height);
        
        applyTransform();
    }
    
    private function get_transform() : Matrix
    {
        return _transform;
    }
    
    private function set_transform(value : Matrix) : Matrix
    {
        _transform = value;
        
        applyTransform();
        return value;
    }
    
    public function applyTransform() : Void
    {
        if (_transform == null) 
            return;
        
        resultTopLeft.setTo(transformX(topLeft.x, topLeft.y, _transform),
                transformY(topLeft.x, topLeft.y, _transform));
        
        resultTopRight.setTo(transformX(topRight.x, topRight.y, _transform),
                transformY(topRight.x, topRight.y, _transform));
        
        resultBottomLeft.setTo(transformX(bottomLeft.x, bottomLeft.y, _transform),
                transformY(bottomLeft.x, bottomLeft.y, _transform));
        
        resultBottomRight.setTo(transformX(bottomRight.x, bottomRight.y, _transform),
                transformY(bottomRight.x, bottomRight.y, _transform));
        
        x = min(resultTopLeft.x, resultTopRight.x, resultBottomLeft.x, resultBottomRight.x);
        y = min(resultTopLeft.y, resultTopRight.y, resultBottomLeft.y, resultBottomRight.y);
        width = max(resultTopLeft.x, resultTopRight.x, resultBottomLeft.x, resultBottomRight.x);
        height = max(resultTopLeft.y, resultTopRight.y, resultBottomLeft.y, resultBottomRight.y);
        
        width -= x;
        height -= y;
    }
	
	function max(x:Float, x1:Float, x2:Float, x3:Float) 
	{
		var val:Float = x;
		
		if (x1 > val)
			val = x1;
			
		if (x2 > val)
			val = x2;
			
		if (x3 > val)
			val = x3;
			
		return val;
	}
	
	function min(x:Float, x1:Float, x2:Float, x3:Float) 
	{
		var val:Float = x;
		
		if (x1 < val)
			val = x1;
			
		if (x2 < val)
			val = x2;
			
		if (x3 < val)
			val = x3;
			
		return val;
	}
}
