package swfdataexporter;

import openfl.errors.Error;
import openfl.utils.ByteArray;
import swfdata.datatags.SwfPackerTag;
import swfdata.datatags.SwfPackerTagDefineSprite;
import swfdata.datatags.SwfPackerTagEnd;
import swfdata.datatags.SwfPackerTagPlaceObject;
import swfdata.datatags.SwfPackerTagRemoveObject;
import swfdata.datatags.SwfPackerTagShowFrame;
import swfdata.datatags.SwfPackerTagSymbolClass;
import swfdataexporter.ExporerTypes;
import swfdataexporter.PlaceObjectExporter;
import swfdataexporter.SwfPackerTagExporter;
import swfdataexporter.SymbolClassExporter;

using Lang;

class SwfTagExporter
{
    private var exporters:Array<SwfPackerTagExporter> = new Array();
    private var importers:Array<SwfPackerTagExporter> = new Array();
    private var tagConstructorsObject:Array<Class<SwfPackerTag>> = new Array();
    
    public function new()
    {
        initialize();
    }
    
    public function exportTags(tags:Array<SwfPackerTag>, output:ByteArray):Void
    {
        var tagsCount:Int = tags.length;
        
        //trace("==========================", tagsCount);
        //trace(tags.join("\n"));
        //trace("==========================");
        
        for (i in 0...tagsCount)
		{
            var exporter:SwfPackerTagExporter = exporters[tags[i].type];
            
            if (exporter != null) 
                exporter.exportTag(tags[i], output)
            else 
				throw new Error("no exporter for tag " + tags[i]);// ["constructor"]);
        }
        
        tags = null;
    }
    
    public function importTags(tags:Array<SwfPackerTag>, input:ByteArray):Void
    {
        var index:Int = 0;
        while (Std.int(input.position) != input.length)
        {
            var tag:SwfPackerTag = importSingleTag(input);
            
            if (tag == null) 
                break;
				
            tags[index++] = tag;
        }
    }
    
    public function importSingleTag(input:ByteArray):SwfPackerTag
    {
        var tagType:Int = input.readUnsignedByte();
        
        var importer:SwfPackerTagExporter = importers[tagType];
        
        if (importer != null) 
        {
            var constructor = tagConstructorsObject[tagType];
            var tag = constructor.createInstance();
            importer.importTag(tag, input);
            
            return tag;
        }
        else 
			throw new Error("no importer for tag " + tagType);
        
        return null;
    }
	
    private function initialize():Void
    {
        importers[ExporerTypes.END] = exporters[0] = new SwfPackerTagExporter(ExporerTypes.END);
        importers[ExporerTypes.SHOW_FRAME] = exporters[1] = new SwfPackerTagExporter(ExporerTypes.SHOW_FRAME);
        
        importers[ExporerTypes.DEFINE_SPRITE] = exporters[39] = new DefineSpriteExporter(this);
        importers[ExporerTypes.PLACE_OBJECT] = exporters[4] = new PlaceObjectExporter();
        importers[ExporerTypes.REMOVE_OBJECT] = exporters[5] = new RemoveObjectExporter();
        importers[ExporerTypes.SYMBOL_CLASS] = exporters[76] = new SymbolClassExporter();
        
        tagConstructorsObject[ExporerTypes.END] = SwfPackerTagEnd;
        tagConstructorsObject[ExporerTypes.SHOW_FRAME] = SwfPackerTagShowFrame;
        tagConstructorsObject[ExporerTypes.DEFINE_SPRITE] = SwfPackerTagDefineSprite;
        tagConstructorsObject[ExporerTypes.PLACE_OBJECT] = SwfPackerTagPlaceObject;
        tagConstructorsObject[ExporerTypes.REMOVE_OBJECT] = SwfPackerTagRemoveObject;
        tagConstructorsObject[ExporerTypes.SYMBOL_CLASS] = SwfPackerTagSymbolClass;
    }
}