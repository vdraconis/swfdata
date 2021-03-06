package swfdataexporter;

#if cpp
import format.lz4.Uncompress;
#end
import openfl.utils.ByteArray;
import renderer.TextureManager;
import swfdata.ShapeLibrary;
import swfdata.atlas.TextureStorage;
import swfdata.datatags.SwfPackerTag;
import swfdataexporter.SwfAtlasExporter;
import swfdataexporter.SwfTagExporter;

class SwfExporter
{
    private var atlasExporter:SwfAtlasExporter;
    private var dataExporter:SwfTagExporter;
    
    public function new(textureStorage:TextureStorage, textureManager:TextureManager)
    {
        atlasExporter = new SwfAtlasExporter(textureStorage, textureManager);
        dataExporter = new SwfTagExporter();
    }
    
    public function clear():Void
    {
        
        
    }
    
    /*public function exportSwf(atlas:ITextureAtlas, shapesList:ShapeLibrary, tagsList:Array<SwfPackerTag>, output:ByteArray):ByteArray
    {
        output.begin();
        
        atlasExporter.exportAtlas(atlas, shapesList, output);
        //output.position = output.byteArray.position;
        trace("EXPORT POS", output.position);
        var atlasPart:Int = output.position;
        
        
        dataExporter.exportTags(tagsList, output);
        
        
        output.end(true);
        
        output.length = output.position;
        
        trace("swf data size", atlasPart, output.length);
        
        output.byteArray.deflate();
        
        trace("compress", output.byteArray.length);
        
        return output;
    }
    
    public function importSwfGenome(name:String, input:ByteArray, shapesList:ShapeLibrary, tagsList:Array<SwfPackerTag>, format:String):GenomeTextureAtlas
    {
        input.byteArray.inflate();
        
        input.begin();
        
        var atlas:GenomeTextureAtlas = atlasExporter.importAtlasGenome(name, input, shapesList, format);
        
        dataExporter.importTags(tagsList, input);
        
        input.end(true);
        
        return atlas;
    }*/
    
    public function importSwfGL(input:ByteArray, shapesList:ShapeLibrary, tagsList:Array<SwfPackerTag>)
	{
		#if cpp
			var bytes:ByteArray = new ByteArray();
			Uncompress.run(input, 0, input.length, bytes, 0);
			input = bytes;
		#else
			input.inflate();
        #end
		
        atlasExporter.impotGLAtlas("none", input, shapesList);
        input.position = input.position;
        dataExporter.importTags(tagsList, input);
	}
	
    /*public function importSwf(input:ByteArray, shapesList:ShapeLibrary, tagsList:Array<SwfPackerTag>):BitmapTextureAtlas
    {
        input.inflate();
		
        
        var atlas:BitmapTextureAtlas = atlasExporter.importBitmapAtlas("none", input, shapesList);
        input.position = input.position;
        dataExporter.importTags(tagsList, input);
        
        return atlas;
    }*/
}
