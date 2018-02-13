package swfdrawer.data;

import openfl.geom.Matrix;

class PooledMatrix extends Matrix 
{
	private static var availableInstance:PooledMatrix;
	
	public static function get(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):PooledMatrix 
	{
		var instance:PooledMatrix = PooledMatrix.availableInstance;
		
		if (instance != null) 
		{
			PooledMatrix.availableInstance = instance.nextInstance;
			instance.nextInstance = null;
			instance.disposed = false;
			
			instance.setTo(a, b, c, d, tx, ty);
		}
		else 
		{
			instance = new PooledMatrix(a, b, c, d, tx, ty);
		}
		
		return instance;
	}
	
	public var disposed:Bool = false;
	public var nextInstance:PooledMatrix;
	
	public function new(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float) 
	{
		super(a, b, c, d, tx, ty);
	}
	
	public function dispose() 
	{
		if (disposed)
			return;
			
		this.nextInstance = PooledMatrix.availableInstance;
		PooledMatrix.availableInstance = this;
		
		disposed = true;
	}
	
	override public function concat(m:Matrix)
	{
		var ma:Float = m.a;
		var mb:Float = m.b;
		var mc:Float = m.c;
		var md:Float = m.d;
		var mtx:Float = m.tx;
		var mty:Float = m.ty;
		
		var a1:Float = a * ma + b * mc;
		b = a * mb + b * md;
		a = a1;
		
		var c1:Float = c * ma + d * mc;
		d = c * mb + d * md;
		c = c1;
		
		var tx1:Float = tx * ma + ty * mc + mtx;
		ty = tx * mb + ty * md + mty;
		tx = tx1;
	}
}