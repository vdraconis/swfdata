package gl.program;

import lime.utils.Log;
import openfl._internal.stage3D.SamplerState;
import openfl._internal.stage3D.opengl.GLProgram3D;
import openfl.display3D.Context3D;
import openfl.display3D.Program3D;

@:access(openfl.display3D.Context3D)
@:access(openfl.display3D.Program3D)
@:access(openfl._internal.stage3D.opengl.GLProgram3D)

class GLSLProgram
{
	var context:Context3D;

	public function new(context:Context3D) 
	{
		this.context = context;
		//Log.level = LogLevel.VERBOSE;
	}
	
	public function useProgram(program:Program3D, shader:DrawerShader)
	{
		GLProgram3D.program = program;
		GLProgram3D.renderSession = context.__renderSession;
		
		//var samplerStates = new Vector<SamplerState> (Context3D.MAX_SAMPLERS);
		var samplerStates = new Array<SamplerState> ();
		
		var glslVertex = shader.glVertexSource;
		var glslFragment = shader.glFragmentSource;
		
		GLProgram3D.__uploadFromGLSL (glslVertex, glslFragment);
		
		for (i in 0...samplerStates.length) {
			
			program.__samplerStates[i] = samplerStates[i];
			
		}
	}
	
}