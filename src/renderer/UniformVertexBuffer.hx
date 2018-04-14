package renderer;

import openfl.Vector;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DVertexBufferFormat;
import openfl.display3D.VertexBuffer3D;

class UniformVertexBuffer 
{
	var buffer:VertexBuffer3D;

	public function new() 
	{
		
	}
	
	var tmp:Vector<Float> = new Vector<Float>();
	
	public function setToContext(context3D:Context3D, firstRegister:Int, data:Vector<Float>, numRegisters:Int = -1) 
	{
		if(buffer == null)
			buffer = context3D.createVertexBuffer(8000, 1);
			
		for (j in 0...4)
		{
			for (i in 0...numRegisters)
			{
				tmp.push(data[i]);
			}
		}
			
		buffer.uploadFromVector(data, 0, numRegisters);
		
		context3D.setVertexBufferAt(3, buffer, 0, Context3DVertexBufferFormat.FLOAT_4);
	}
	
}