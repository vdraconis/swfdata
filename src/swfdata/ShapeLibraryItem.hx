package swfdata;

import openfl.geom.Matrix;
import swfdata.atlas.TextureTransform;

class ShapeLibraryItem
{
    public var shapeData:ShapeData;
    public var transform:TextureTransform = new TextureTransform(0, 0);
    
    public function new()
    {
        
        
    }
    
    public function clear():Void
    {
        shapeData = null;
        transform = null;
    }
    
    @:meta(Inline())

    @:final public function correctScale(a:Float, a2:Float):Float
    {
        if (a == a2) 
            return a2;
        
        if (a < 0) 
            a = -a;
        
        if (a > a2) 
            return a
        else 
			return a2;
    }

    @:final public function checkTransform(matrix:Matrix, tx:Float, ty:Float):Void
    {
        transform.scaleX = correctScale(matrix.a, transform.scaleX);  //Math.max(Math.abs(matrix.a), transform.scaleX);  
        transform.scaleY = correctScale(matrix.d, transform.scaleY);  //Math.max(Math.abs(matrix.d), transform.scaleY);  
        
        transform.tx = tx;
        transform.ty = ty;
    }
}
