package gl.program;

import renderer.Renderer;

class DrawerShader
{
	var __glFragmentSource:String = 
		"
		precision highp float;
		uniform vec4 fc0;
		uniform vec4 fc1;
		varying vec4 v0;
		varying vec4 v1;
		varying vec4 v2;
		uniform sampler2D sampler0;
		void main() {
			vec4 ft0;
			vec4 ft1;
			ft0 = texture2D(sampler0, v0.xy); // tex
			ft0 = max(ft0, fc1); // max
			ft0.xyz = ft0.xyz / ft0.www; // div
			ft0 = ft0 * v1; // mul
			ft0 = ft0 + v2; // add
			ft0.xyz = ft0.xyz * ft0.www; // mul
			ft1.w = ft0.w - fc0.w; // sub
			if (any(lessThan(ft1.wwww, vec4(0)))) discard;
			gl_FragColor = ft0; // mov
		}
		";
	
	var __glVertexSource:String = 
		"
		precision highp float;
		attribute vec4 va0;
		attribute vec4 va1;
		attribute vec4 va2;
		uniform mat4 vc0;
		uniform vec4 vc4["+ Renderer.MAX_VERTEX_CONSTANTS +"];
		varying vec4 v2;
		varying vec4 v1;
		varying vec4 v0;
		uniform vec4 vcPositionScale;
		void main() {
			vec4 vt3;
			vec4 vt1;
			vec4 vt0;
			vec4 vt2;
			vt0 = va2; // mov
			vt0 = va0; // mov
			int index = int(va2.x);
			vt1 = va0.xyyy * vc4[index + 1].zwww; // mul
			vt2 = vt1.xyyy * vc4[index].xyyy; // mul
			vt2.x = vt2.x + vt2.y; // add
			vt2.x = vt2.x + vc4[index + 1].x; // add
			vt3 = vt1.xyyy * vc4[index].zwww; // mul
			vt3.x = vt3.x + vt3.y; // add
			vt3.x = vt3.x + vc4[index + 1].y; // add
			vt2.y = vt3.x; // mov
			vt2.zw = vt0.ww; // mov
			vt3 = vt2 * vc0; // m44
			gl_Position = vt3; // mov
			vt0.xy = va1.xy * vc4[index + 2].zw; // mul
			vt0.xy = vt0.xy + vc4[index + 2].xy; // add
			v0 = vt0; // mov
			v1 = vc4[index + 3]; // mov
			v2 = vc4[index + 4]; // mov
			gl_Position *= vcPositionScale;
		}
		";
	
	public var glVertexSource(get, set):String;
	public var glFragmentSource(get, set):String;
	
	public function new () 
	{
		//super ();
	}
	
	//private override function __update ():Void 
	//{
	//	super.__update ();
	//}
	
	private function get_glFragmentSource ():String {
		
		return __glFragmentSource;
		
	}
	
	
	private function set_glFragmentSource (value:String):String {
		
		//if (value != __glFragmentSource) {
			
			//__glSourceDirty = true;
			
		//}
		
		return __glFragmentSource = value;
		
	}
	
	
	private function get_glVertexSource ():String {
		
		return __glVertexSource;
		
	}
	
	
	private function set_glVertexSource (value:String):String {
		
		//if (value != __glVertexSource) {
			
		//	__glSourceDirty = true;
		//	
		//}
		
		return __glVertexSource = value;
		
	}
}