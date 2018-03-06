package swfdataexporter;

import lime.graphics.PixelFormat;
import openfl.display.BitmapData;
import openfl.display3D.Context3DTextureFormat;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import renderer.TextureManager;
import swfdata.ShapeData;
import swfdata.ShapeLibrary;
import swfdata.atlas.BitmapTextureAtlas;
import swfdata.atlas.GLSubTexture;
import swfdata.atlas.GLTextureAtlas;
import swfdata.atlas.SubTexture;
import swfdata.atlas.TextureId;
import swfdata.atlas.TextureSource;
import swfdata.atlas.TextureStorage;
import swfdata.atlas.TextureTransform;

using utils.ReadUtils;

@:access(openfl.display)
class SwfAtlasExporter
{
	#if textureFromBytes
	#else
    private var bitmapBytes:ByteArray = new ByteArray();
	#end
	
	var textureStorage:TextureStorage;
	var textureManager:TextureManager;
    
    public function new(textureStorage:TextureStorage, textureManager:TextureManager)
    {
		this.textureManager = textureManager;
		this.textureStorage = textureStorage;
    }
    
    public function exportAtlas(atlas:BitmapTextureAtlas, shapesList:ShapeLibrary, output:ByteArray):Void
    {
        var bitmap:BitmapData = atlas.atlasData;
        var bitmapBytes:ByteArray = bitmap.getPixels(bitmap.rect);
        
        if (bitmap.width < 2 || bitmap.height < 2) 
            Internal_trace.trace("Error: somethink wrong with atlas data");
        
        output[output.position++] = atlas.padding;
        output.writeInt(bitmapBytes.length);
        output.writeShort(bitmap.width);
        output.writeShort(bitmap.height);
        
        output.writeBytes(bitmapBytes, 0, bitmapBytes.length);
        
        output.writeShort(atlas.texturesCount);
        
        //trace('pre write', output.position);
        
        for (texture in atlas.subTextures)
        {
            output.writeShort(texture.id);
            
            output.writeTextureTransform(texture.transform);
            output.writeRectangle(texture.bounds);
            
            output.writeRectangle(shapesList.getShape(texture.id).shapeData.shapeBounds);
        }  //output.end(false);  
    }
		
	public function impotGLAtlas(name:String, input:ByteArray, shapesList:ShapeLibrary)
	{
		var textureAtlas:GLTextureAtlas;
		
		input.position = 0;
		
		var padding:Int = input.readUnsignedByte();
		var bitmapSize:Int = input.readInt();
		var width:Int = input.readShort();
		var height:Int = input.readShort();
		
		#if textureFromBytes
		var bitmapBytes = new ByteArray();
		#else
		bitmapBytes.length = 0;
		#end
		
		input.readBytes(bitmapBytes, 0, bitmapSize);
		
		if (width < 2 || height < 2) 
			trace("Error: something wrong with atlas data");
			
		#if !textureFromBytes
		var atlasData:BitmapData = new BitmapData(width, height, true, 0x0);
		atlasData.image.setPixels (@:privateAccess atlasData.rect.__toLimeRectangle(), bitmapBytes, PixelFormat.BGRA32, bitmapBytes.endian);
		#else
		var atlasData = bitmapBytes;
		#end
		
		var textureSource = new TextureSource(atlasData, width, height, textureManager);
		
		var atlasId = textureStorage.getNextTextureId();
		
		var texturesCount:Int = input.readShort();
		
		var r:Rectangle = new Rectangle();
		for (i in 0...texturesCount)
		{
			var id:Int = input.readShort();
			var textureTransform:TextureTransform = input.readTextureTransform();
			var textureRegion:Rectangle = input.readRectangle();
			var shapeBounds:Rectangle = input.readRectangle();
			
			//if (textureTransform.scaleX != 1 || textureTransform.scaleY != 1)
			/*
				r.setTo(textureRegion.x + padding, textureRegion.y + padding, textureRegion.width - padding * 2, 1);
				atlasData.fillRect(r, 0xFF00FF00);
				
				
				r.setTo(textureRegion.x + padding, textureRegion.y + padding, 1, textureRegion.height - padding *2);
				atlasData.fillRect(r, 0xFF00FF00);
				
				
				r.setTo(textureRegion.x + textureRegion.width - padding, textureRegion.y + padding, 1, textureRegion.height - padding *2);
				atlasData.fillRect(r, 0xFF00FF00);
				
				
				r.setTo(textureRegion.x + padding, textureRegion.y + textureRegion.height - padding, textureRegion.width - padding * 2, 1);
				atlasData.fillRect(r, 0xFF00FF00);
			*/	
			
			var textureId = new TextureId(atlasId, id);
			
			shapesList.addShape(new ShapeData(textureId, shapeBounds));
			
			var texture:GLSubTexture = new GLSubTexture(textureId, textureRegion, textureTransform, textureSource, padding, Context3DTextureFormat.BGRA);
			textureStorage.putTexture(textureId, texture);
		}
		
		textureSource.createGlData(Context3DTextureFormat.BGRA);
		textureSource.uploadToGpu();
	}
	
	//public function importBitmapAtlas(name:String, input:ByteArray, shapesList:ShapeLibrary):BitmapTextureAtlas
    //{
        //var textureAtlas:BitmapTextureAtlas;
        //
        //var padding:Int = input.readUnsignedByte();
        //var bitmapSize:Int = input.readInt();
        //var width:Int = input.readShort();
        //var height:Int = input.readShort();
        //
        //bitmapBytes.length = 0;
		//
		//trace('importing atlas', input.bytesAvailable, padding, width, height, bitmapSize);
        //
        //input.readBytes(bitmapBytes, 0, bitmapSize);
		//
        //if (width < 2 || height < 2) 
            //trace("Error: somethink wrong with atlas data");
			//
        //textureAtlas = new BitmapTextureAtlas(width, height, padding);
		//textureAtlas.atlasData.setPixels(textureAtlas.atlasData.rect, bitmapBytes);
        //
        //var texturesCount:Int = input.readShort();
        //
        ////trace('pre read', input.position);
        //
        //var r:Rectangle = new Rectangle();
        //for (i in 0...texturesCount){
            //var id:Int = input.readShort();
            //
            //var textureTransform:TextureTransform = input.readTextureTransform();
            //var textureRegion:Rectangle = input.readRectangle();
            //var shapeBounds:Rectangle = input.readRectangle();
            //
            ////trace("read", input.position);
            //
            ///*
				////if (textureTransform.scaleX != 1 || textureTransform.scaleY != 1)
				////{
					//r.setTo(textureRegion.x + padding, textureRegion.y + padding, textureRegion.width - padding * 2, 1);
					//bitmapData.fillRect(r, 0xFF00FF00);
					//
					//
					//r.setTo(textureRegion.x + padding, textureRegion.y + padding, 1, textureRegion.height - padding *2);
					//bitmapData.fillRect(r, 0xFF00FF00);
					//
					//
					//r.setTo(textureRegion.x + textureRegion.width - padding, textureRegion.y + padding, 1, textureRegion.height - padding *2);
					//bitmapData.fillRect(r, 0xFF00FF00);
					//
					//
					//r.setTo(textureRegion.x + padding, textureRegion.y + textureRegion.height - padding, textureRegion.width - padding * 2, 1);
					//bitmapData.fillRect(r, 0xFF00FF00);
				////}	
				//*/
            //shapesList.addShape(/*null,*/ new ShapeData(id, shapeBounds));
            //var texture:BitmapSubTexture = new BitmapSubTexture(id, textureRegion, textureTransform);
            //
            //textureAtlas.putTexture(texture);
        //}  //input.bitsReader.clear();  
        //
        //return textureAtlas;
    //}
}