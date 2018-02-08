package swfdrawer.data;

import openfl.geom.Matrix;

class DrawerMatrixPool
{
    public static var instance(get, never):DrawerMatrixPool;

    private static var _instance:DrawerMatrixPool;
    
    private static function get_instance():DrawerMatrixPool
    {
        if (_instance == null) 
            _instance = new DrawerMatrixPool();
        
        return _instance;
    }
    
    private var count:Int = 0;
    private var matricesPool:Array<Matrix> = new Array<Matrix>();
    
    public function new()
    {
        
        
    }
    
    public function getMatrix():Matrix
    {
        if (count > 0) 
        {
            count--;
            return matricesPool.shift();
        }
        else 
        {
            return new Matrix();
        }
    }
    
    public function disposeMatrix(matrix:Matrix):Void
    {
        matricesPool[count++] = matrix;
    }
}