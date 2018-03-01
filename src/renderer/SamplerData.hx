package renderer;

import openfl.display3D.Context3D;
import openfl.display3D.Context3DMipFilter;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DWrapMode;

class SamplerData 
{
	@:isVar public var smooth(get, set):Bool;
	
	public var wrapMode:Context3DWrapMode;
	public var filter:Context3DTextureFilter;
	public var mipFilter:Context3DMipFilter;
	
	public function new(wrapMode:Context3DWrapMode = Context3DWrapMode.CLAMP, filter:Context3DTextureFilter = Context3DTextureFilter.LINEAR, mipFilter:Context3DMipFilter = Context3DMipFilter.MIPNONE) 
	{
		this.mipFilter = mipFilter;
		this.filter = filter;
		this.wrapMode = wrapMode;
	}
	
	public function toString():String 
	{
		return "[SamplerData wrapMode=" + wrapMode + " filter=" + filter + " mipFilter=" + mipFilter + "]";
	}
	
	inline public function isEqual(samplerB:SamplerData):Bool
	{
		return this == samplerB || !(wrapMode != samplerB.wrapMode || filter != samplerB.filter || mipFilter != samplerB.mipFilter);
	}
	
	inline public function apply(context:Context3D, index:Int) 
	{
		context.setSamplerStateAt(index, wrapMode, filter, mipFilter);
	}
	
	function get_smooth():Bool 
	{
		return smooth;
	}
	
	function set_smooth(value:Bool):Bool 
	{
		filter = value? Context3DTextureFilter.LINEAR:Context3DTextureFilter.NEAREST;
		return smooth = value;
	}
}