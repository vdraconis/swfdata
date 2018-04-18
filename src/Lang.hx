package;

class Lang 
{
	inline public static function as<T>(value:Dynamic, type:Class<T>):Null<T> {
		#if flash
			return untyped __as__(value, type);
		#else
			return Std.is(value, type) ? value : null;
		#else
			return value;
		#end
	}
	
	inline public static function as2<T>(value:Dynamic, type:Class<T>):Null<T> {
		#if flash
			return untyped __as__(value, type);
		#else
			return value;
		#else
			return value;
		#end
	}
	
	inline public static function createInstance<T:Dynamic>(cl:Class<T>):T
	{
		#if flash
			return untyped __flash__('new {0}();', cl);
		#elseif js
			return untyped __js__('new {0}();', cl);
		#else
			return Type.createInstance(cl, []);
		#end
	}
    
}