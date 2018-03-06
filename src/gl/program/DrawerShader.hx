package gl.program;

import renderer.Renderer;

class DrawerShader
{
	var __glFragmentSource:String = 
		"
		precision mediump float;
		//uniform vec4 fc0;
		//uniform vec4 fc1;
		varying vec2 uv;
		varying vec4 v1;
		varying vec4 v2;
		uniform sampler2D sampler0;
		void main() {
			vec4 ft0;
			vec4 ft1;
			ft0 = texture2D(sampler0, uv.xy); // tex
			//ft0 = max(ft0, fc1); // max
			ft0.xyz = ft0.xyz / ft0.www; // div
			ft0 = ft0 * v1; // mul
			ft0 = ft0 + v2; // add
			ft0.xyz = ft0.xyz * ft0.www; // mul
			//ft1.w = ft0.w - fc0.w; // sub
			//if (any(lessThan(ft1.wwww, vec4(0)))) discard;
			gl_FragColor = ft0; // mov
		}
		";
	
	var __glVertexSource:String = 
		"
		precision mediump float;
		
		attribute vec3 va0;
		attribute vec2 va1;
		attribute float va2;
		
		uniform mat4 vc0;
		uniform vec4 vc4["+ Renderer.MAX_VERTEX_CONSTANTS +"];
		
		varying vec4 v2;
		varying vec4 v1;
		varying vec2 uv;
		
		uniform vec4 vcPositionScale;
		
		void main() {
		vec2 vt3;
			vec2 vt1;
			vec4 vt0;
			vec4 vt2 = vec4(0, 0, 1, 1);
			
			int index = int(va2);
			vec4 transform = vc4[index];
			vec4 texture = vc4[index + 1];
			vec2 uvPosition = vc4[index + 2].xy;
			vec2 uvScale = vc4[index + 2].zw;
			vec4 colorAdd = vc4[index + 3];
			vec4 colorMul = vc4[index + 4];
			
			vt1 = va0.xy * texture.zw;
			vt2.xy = vt1.xy * transform.xy;
			vt2.x = vt2.x + vt2.y;
			vt2.x = vt2.x + texture.x;
			vt3 = vt1.xy * transform.zw;
			vt3.x = vt3.x + vt3.y;
			vt3.x = vt3.x + texture.y;
			vt2.y = vt3.x;
			
			gl_Position = vt2 * vc0;
			
			uv.xy = va1.xy * uvScale.xy + + uvPosition.xy;
			
			v1 = colorAdd; // mov
			v2 = colorMul; // mov
			//gl_Position *= vcPositionScale;
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