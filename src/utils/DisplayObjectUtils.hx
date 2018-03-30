package utils;

import swfdata.DisplayObjectData;
import swfdata.DisplayObjectTypes;
import swfdata.IDisplayObjectContainer;
import swfdata.ITimelineContainer;
import swfdata.MovieClipData;
import swfdata.ShapeData;
import swfdata.SpriteData;

@:access(swfdata)
class DisplayObjectUtils
{
	inline public static function asUpdatable(instance:DisplayObjectData):IUpdatable
	{
		if(instance.displayObjectType == DisplayObjectTypes.MOVIE_CLIP_TYPE)
			return untyped instance;
		else
			return null;
	}
	
	inline public static function asUpdatable2(instance:DisplayObjectData):Null<IUpdatable>
	{
		return untyped instance;
	}
	
	inline public static function asDisplayObjectContainer(instance:DisplayObjectData):Null<IDisplayObjectContainer>
	{
		if (instance.displayObjectType == DisplayObjectTypes.MOVIE_CLIP_TYPE)
			return untyped instance;
		else
			return null;
	}
	
	inline public static function asDisplayObjectContainer2(instance:DisplayObjectData):Null<IDisplayObjectContainer>
	{
		return untyped instance;
	}
	
	inline public static function asSpriteData(instance:DisplayObjectData):Null<SpriteData>
	{
		if (instance.displayObjectType == DisplayObjectTypes.MOVIE_CLIP_TYPE)
			return untyped instance;
		else
			return null;
	}
	
	inline public static function asSpriteData2(instance:DisplayObjectData):Null<SpriteData>
	{
		return untyped instance;
	}
	
	inline public static function asMovieClip(instance:DisplayObjectData):Null<MovieClipData>
	{
		if (instance.displayObjectType == DisplayObjectTypes.MOVIE_CLIP_TYPE)
			return untyped instance;
		else
			return null;
	}
	
	inline public static function asMovieClip2(instance:DisplayObjectData):MovieClipData
	{
		return untyped instance;
	}
	
	inline public static function asTimlineContainer(instance:DisplayObjectData):Null<ITimelineContainer>
	{
		return untyped instance;
	}
	
	inline public static function asTimlineContainer2(instance:DisplayObjectData):Null<IDisplayObjectContainer>
	{
		if (instance.displayObjectType >= DisplayObjectTypes.SPRITE_TYPE)
			return untyped instance;
		else
			return null;
	}
	
	inline public static function asShape(instance:DisplayObjectData):Null<ShapeData>
	{
		if (instance.displayObjectType == DisplayObjectTypes.SHAPE_TYPE)
			return untyped instance;
		else
			return null;
	}
	
	inline public static function asShape2(instance:DisplayObjectData):Null<ShapeData>
	{
		return untyped instance;
	}
}