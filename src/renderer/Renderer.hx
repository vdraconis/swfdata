package renderer;

import openfl.Vector;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DProgramType;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Program3D;
import openfl.display3D.textures.TextureBase;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import renderer.BaseAgalShader2;
import renderer.BatchGeometry;
import swfdata.ColorData;
import swfdata.atlas.GLSubTexture;
import swfdata.atlas.GLTextureAtlas;
import swfdata.atlas.TextureStorage;

class Renderer
{
    public var smooth(get, set):Bool;
    public var alphaThreshold(get, set):Float;

    static inline var DEFAULT_THRESHOLD:Float = 0.1;
    static inline var MAX_VERTEX_CONSTANTS:Int = 204;  //may change in different profiles  
    
    static var registersPerGeometry:Int = 5;
    static var batchRegistersSize:Int = (MAX_VERTEX_CONSTANTS - 4);
    static var batchConstantsSize:Int = batchRegistersSize * 4;
    static var batchSize:Int = Std.int(batchRegistersSize / registersPerGeometry);
    
    static var drawingGeometry:BatchGeometry = new BatchGeometry(batchSize, registersPerGeometry);
    
    static var blendModes:Vector<BlendMode> = BlendMode.getBlendModesList();
	
	static var _program3D:Program3D;
    static var drawingList:Array<DrawingList> = new Array<DrawingList>();
    
	public var textureStorage:TextureStorage;
	
    var fragmentData:Vector<Float>;
	
    var drawingListSize:Int = 0;
    
    var currentTexture:TextureBase = null;
    var currentSamplerData:SamplerData;
    
    var useBlendModeRendering:Bool = true;
    
    var _smooth:Bool = true;
	
	var context3D:Context3D;
	
	var projection:ProjectionMatrix = new ProjectionMatrix().ortho(800, 800, null);
    
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
        
        _program3D = new BaseAgalShader().makePrgoram(context3D);
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
    
    private function set_alphaThreshold(value:Float):Float
    {
        fragmentData[3] = value;
        return value;
    }
    
    private function get_alphaThreshold():Float
    {
        return fragmentData[3];
    }
    
    inline public function draw(texture:GLSubTexture, matrix:Matrix, colorData:ColorData, blendMode:Int = 0)
    {
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
        var currentDrawingList:DrawingList = getDrawingList();
		var currentDrawingTexture = currentDrawingList.texture;
        if ((currentDrawingTexture != null && currentDrawingTexture.textureSource.glData != texture.textureSource.glData) || currentDrawingList.isFull || (useBlendModeRendering && currentDrawingList.blendMode != blendMode))
        {
            drawingListSize++;
            currentDrawingList = getDrawingList();
            currentDrawingList.blendMode = blendMode;
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
        context3D.setProgram(_program3D);
        context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, projection, true);
        context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fragmentData, 2);
        context3D.setDepthTest(false, Context3DCompareMode.ALWAYS);
		
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
            if (currentDrawingList == null)
				return;
				
			setTexture(currentDrawingList.texture.textureSource.glData, context3D);
			
			var registersSize:Int = currentDrawingList.registersSize;
			var trianglesNum:Int = Std.int(registersSize * triangleToRegisterRate);
			
			var blendMode:BlendMode = blendModes[currentDrawingList.blendMode];
			context3D.setBlendFactors(blendMode.src, blendMode.dst);
			
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, currentDrawingList.data, currentDrawingList.data.length);
			context3D.drawTriangles(drawingGeometry.indexBuffer, 0, trianglesNum);
			
			currentDrawingList.clear();
        }
        
        currentTexture = null;
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