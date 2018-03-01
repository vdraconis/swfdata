package renderer;

import openfl.display3D.Context3D;
import openfl.display3D.IndexBuffer3D;

class Quad extends BaseMesh
{
	
	static var __indexBuffer:IndexBuffer3D;
	
	public function new() 
	{
		super();
		
		var aspect:Float = 1 / 1;
		
		vertexDataRaw[0] =  -0.5 * aspect;	vertexDataRaw[1]  =  -0.5 * aspect;	vertexDataRaw[2]  =	 0.5 * aspect;
		vertexDataRaw[3] =   0.5 * aspect;	vertexDataRaw[4]  =  -0.5 * aspect;	vertexDataRaw[5]  =	 0.5 * aspect;
		vertexDataRaw[6] = 	 0.5 * aspect;	vertexDataRaw[7]  =   0.5 * aspect;	vertexDataRaw[8]  =	 0.5 * aspect;
		vertexDataRaw[9] =  -0.5 * aspect;	vertexDataRaw[10] =   0.5 * aspect;	vertexDataRaw[11] =  0.5 * aspect;
		
		
		indexDataRaw[0] = 0;	indexDataRaw[1] = 1;	indexDataRaw[2] = 2;
		indexDataRaw[3] = 2;	indexDataRaw[4] = 3;	indexDataRaw[5] = 0;
	}
	
	override public function uploadToGpu(context3D:Context3D):Void 
	{
		indexBuffer = __indexBuffer;
		
		super.uploadToGpu(context3D);
		
		if (__indexBuffer == null)
			__indexBuffer = indexBuffer;
	}
}