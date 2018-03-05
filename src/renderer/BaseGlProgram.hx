package renderer;

import gl.program.DrawerShader;
import gl.program.GLSLProgram;
import openfl.display3D.Context3D;
import openfl.display3D.Program3D;
import openfl.display3D.Program3D.Uniform;

@:access(openfl.display3D.Program3D)
class BaseGlProgram
{
	var isCompiled:Bool = false;
	var glProgram:gl.program.GLSLProgram;
	var uniformMap:Map<String, Uniform> = new Map();
	public var program:Program3D;
	
	public function new() 
	{
		
	}
	
	public function makePrgoram(context:Context3D)
	{
		program = context.createProgram();
		
		if (!isCompiled)
		{
			var shader = new DrawerShader();
			glProgram = new GLSLProgram(context);
			glProgram.useProgram(program, shader);
			processUniforms();
		}
	}
	
	public function setUniformRegistersCount(uniformName:String, registersCount:Int)
	{
		uniformMap.get(uniformName).regCount = registersCount;
	}
	
	public function processUniforms()
	{
		var uniforms:Array<Uniform> = @:privateAccess program.__vertexUniformMap.__uniforms;
		
		for (uniform in uniforms)
		{
			uniformMap.set(uniform.name, uniform);
		}
	}
}