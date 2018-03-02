package;

class Lang 
{
	inline public static function as<T>(value:Dynamic, type:Class<T>):Null<T> {
		#if flash
			return untyped __as__(value, type);
		#else
			return Std.is(value, type) ? value : null;
		#end
	}
	
	inline public static function as2<T>(value:Dynamic, type:Class<T>):Null<T> {
		#if flash
			return untyped __as__(value, type);
		#else
			return value;
		#end
	}
}