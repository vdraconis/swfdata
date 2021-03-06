package renderer;

import openfl.display3D.Context3D;
import openfl.display.BitmapData;
import openfl.display3D.textures.Texture;

class TextureManager
{
	var context3D:Context3D;
	
	public function new(context3D:Context3D) 
	{
		this.context3D = context3D;
	}
	
	public function createTexture(id:Int, width:Int, height:Int, format:String):Texture
	{
		return context3D.createTexture(width, height, format, false);
	}
	
}