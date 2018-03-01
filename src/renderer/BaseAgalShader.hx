package renderer;

import gl.program.DrawerShader;
import gl.program.GLSLProgram;
import openfl.display3D.Context3D;
import openfl.display3D.Program3D;

class BaseAgalShader
{
	var isCompiled:Bool = false;
	var glProgram:gl.program.GLSLProgram;
	
	public function new() 
	{
		
	}
	
	public function makePrgoram(context:Context3D):Program3D
	{
		var program = context.createProgram();
		
		if (!isCompiled)
		{
			var shader = new DrawerShader();
			glProgram = new GLSLProgram(context);
			glProgram.useProgram(program, shader);
		}
		
		return program;
	}
}