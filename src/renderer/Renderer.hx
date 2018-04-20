package renderer;

import haxe.ds.Vector;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DProgramType;
import openfl.display3D.textures.TextureBase;
import openfl.geom.Matrix;
import renderer.BatchGeometry;
import swfdata.ColorData;
import swfdata.atlas.GLSubTexture;
import swfdata.atlas.TextureStorage;
import swfdrawer.data.DrawingData;

class Renderer
{
    public var smooth(get, set):Bool;
    //public var alphaThreshold(get, set):Float;

    static inline var DEFAULT_THRESHOLD:Float = 0.1;
    public static inline var MAX_VERTEX_CONSTANTS:Int = 204;  //may change in different profiles  
    
    static var registersPerGeometry:Int = 5;
    static var batchRegistersSize:Int = (MAX_VERTEX_CONSTANTS - 4);
    static var batchConstantsSize:Int = batchRegistersSize * 4;
    static var batchSize:Int = Std.int(batchRegistersSize / registersPerGeometry);
    
    static var drawingGeometry:BatchGeometry = new BatchGeometry(batchSize, registersPerGeometry);
    
    static var blendModes:Vector<BlendMode> = BlendMode.getBlendModesList();
	
	var glProgram:BaseGlProgram;
    var drawingList:Array<DrawingList> = new Array<DrawingList>();
    
	public var textureStorage:TextureStorage;
	
    var fragmentData:Vector<Float>;
	
    var drawingListSize:Int = 0;
    var currentDrawingList:DrawingList;
	
    var currentTexture:TextureBase = null;
    var currentSamplerData:SamplerData;
	
	var currentBlendMode:BlendMode = new BlendMode(null, null);
    
    var useBlendModeRendering:Bool = true;
    
    var _smooth:Bool = true;
	
	var context3D:Context3D;
	
	var projection:ProjectionMatrix;
	var isViewportUpdated:Bool = true;
    
    public function new(context3D:Context3D, textureStorage:TextureStorage)
    {
		this.context3D = context3D;
		this.textureStorage = textureStorage;
		
		fragmentData = new Vector(8);
		fragmentData[0] = 0; fragmentData[1] = 0; fragmentData[2] = 0; fragmentData[3] = DEFAULT_THRESHOLD;
		fragmentData[4] = 0; fragmentData[5] = 0; fragmentData[6] = 0; fragmentData[7] = 0.0001;
        
        currentSamplerData = new SamplerData();
        
        if (drawingGeometry.uploaded == false)
        {
            drawingGeometry.uploadToGpu(context3D);
        }
        
        glProgram = new BaseGlProgram();
		glProgram.makePrgoram(context3D);
    }
    
    private function set_smooth(value:Bool):Bool
    {
        if (_smooth == value)
        {
            return value;
        }
        
        _smooth = value;
        currentSamplerData.smooth = _smooth;
        return value;
    }
    
    private function get_smooth():Bool
    {
        return _smooth;
    }
    
    //private function set_alphaThreshold(value:Float):Float
    //{
    //    fragmentData[3] = value;
    //    return value;
   // }
    
    //private function get_alphaThreshold():Float
    //{
    //    return fragmentData[3];
    //}
    
    inline public function draw(texture:GLSubTexture, matrix:Matrix, drawingData:DrawingData)
    {
		var blendMode = drawingData.blendMode;
		var colorData = drawingData.colorData;
		
        var a:Float = matrix.a;
        var b:Float = matrix.b;
        var c:Float = matrix.c;
        var d:Float = matrix.d;
        var tx:Float = matrix.tx;
        var ty:Float = matrix.ty;
        
        var pivotX:Float = texture.pivotX;
        var pivotY:Float = texture.pivotY;
        
        if (pivotX != 0 || pivotY != 0)
        {
            tx = tx - pivotX * a - pivotY * c;
            ty = ty - pivotX * b - pivotY * d;
        }
        
        //TODO: optimisation
        if (currentDrawingList != null)
		{
			var currentDrawingTexture = currentDrawingList.texture;
			if ((currentDrawingTexture != null && currentDrawingTexture.textureSource.glData != texture.textureSource.glData) || currentDrawingList.isFull || (useBlendModeRendering && currentDrawingList.blendMode != blendMode))
			{
				drawingListSize++;
				currentDrawingList = getDrawingList();
				currentDrawingList.blendMode = blendMode;
			}
		}
		else
		{
			currentDrawingList = getDrawingList();
		}
		
        currentDrawingList.addDrawingData(a, b, c, d, tx, ty, texture, colorData);
    }
    
    inline public function getDrawingList():DrawingList
    {
        var currentDrawingList:DrawingList = drawingList[drawingListSize];
        
        if (currentDrawingList == null)
        {
            currentDrawingList = new DrawingList(batchRegistersSize, registersPerGeometry);
            drawingList[drawingListSize] = currentDrawingList;
        }
        
        return currentDrawingList;
    }
    
	inline public function setTexture(texture:TextureBase, context3D:Context3D)
    {
        if (currentTexture == texture)
        {
            return;
        }
        
        currentTexture = texture;
        context3D.setTextureAt(0, currentTexture);
    }
	
	public function begin()
	{
		//premultiplied because textures is BitmapData
        //RenderSupport.setBlendFactors(true, blendmode);// starling slow as 90 years old granny
        //context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA); //normal
        
        //context.setBlendFactors(Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA); //normal
        //context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA); //layer
        context3D.setProgram(glProgram.program);
		if (isViewportUpdated)
		{
			isViewportUpdated = false;
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, projection, true);
			//context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fragmentData, 2);
			context3D.setDepthTest(false, Context3DCompareMode.ALWAYS);
		}
		
		//drawingGeometry and currentTexture reseted if we have OpenFL rendere calls wich work not like "adobe stage3D"
		//also need to reset texture in slot because OpenFL didnt do that
		context3D.setTextureAt(0, null);
		currentTexture = null;
		drawingGeometry.setToContext(context3D);
		
		currentSamplerData.apply(context3D, 0);
	}
    
    public function render()
    {
        var triangleToRegisterRate:Float = 2 / registersPerGeometry;
        var length:Int = drawingListSize + 1;
		
        for (i in 0...length)
        {
            var currentDrawingList:DrawingList = drawingList[i];
            if (currentDrawingList == null || currentDrawingList.length == 0)
				continue;
				
			setTexture(currentDrawingList.texture.textureSource.glData, context3D);
			
			var registersSize:Int = currentDrawingList.registersSize;
			var trianglesNum:Int = Std.int(registersSize * triangleToRegisterRate);
			
			var blendMode:BlendMode = blendModes[currentDrawingList.blendMode];
			
			if (!currentBlendMode.equalse(blendMode)) 
			{
				currentBlendMode.copyFrom(blendMode);
				context3D.setBlendFactors(blendMode.src, blendMode.dst);
			}
			
			glProgram.setUniformRegistersCount("vc4", currentDrawingList.registersSize);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, currentDrawingList.data, currentDrawingList.registersSize);
			context3D.drawTriangles(drawingGeometry.indexBuffer, 0, trianglesNum);
			
			currentDrawingList.clear();
        }
        
        currentTexture = null;
        currentDrawingList = null;
        drawingListSize = 0;
    }
    
	public function end() 
	{
		context3D.present();
	}
	
    public function dispose()
    {
        
    }
}