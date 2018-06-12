package swfdrawer.data;

import openfl.geom.Matrix;

class PooledMatrix extends Matrix 
{
	private static var availableInstance:PooledMatrix;
	private static var createdInstances:Int = 0;
	
	inline public static function getWithAndConcat(m1:Matrix, m2:Matrix):PooledMatrix 
	{
		var a = m1.a;
		var b = m1.b;
		var c = m1.c;
		var d = m1.d;
		var tx = m1.tx;
		var ty = m1.ty;
		
		var ma = m2.a;
		var mb = m2.b;
		var mc = m2.c;
		var md = m2.d;
		var mtx = m2.tx;
		var mty = m2.ty;
		
		untyped var a1 = a * ma + (b * mc);
		untyped b = a * mb + (b * md);
		a = a1;
		
		untyped var c1 = c * ma + (d * mc);
		d = c * mb + d * md;
		c = c1;
		
		untyped var tx1 = tx * ma + (ty * mc + mtx);
		untyped ty = tx * mb + (ty * md + mty);
		tx = tx1;
		
		return get(a, b, c, d, tx, ty);
	}
	
	inline public static function get(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):PooledMatrix 
	{
		var instance:PooledMatrix = PooledMatrix.availableInstance;
		
		if (instance != null) 
		{
			PooledMatrix.availableInstance = instance.nextInstance;
			instance.nextInstance = null;
			instance.isFree = false;
			
			instance.setTo(a, b, c, d, tx, ty);
		}
		else 
		{
			instance = new PooledMatrix(a, b, c, d, tx, ty);
			createdInstances++;
		}
		
		return instance;
	}
	
	public var isFree:Bool = false;
	public var nextInstance:PooledMatrix;
	
	public function new(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float) 
	{
		super(a, b, c, d, tx, ty);
	}
	
	inline public function free() 
	{
		if (isFree)
			return;
			
		this.nextInstance = PooledMatrix.availableInstance;
		PooledMatrix.availableInstance = this;
		
		isFree = true;
	}
	
	inline override public function concat(m:Matrix)
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