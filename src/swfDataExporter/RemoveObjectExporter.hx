package swfdataexporter;

import openfl.errors.Error;
import openfl.utils.ByteArray;
import swfdata.datatags.SwfPackerTag;
import swfdata.datatags.SwfPackerTagRemoveObject;
import swfdataexporter.ExporerTypes;
import swfdataexporter.SwfPackerTagExporter;

class RemoveObjectExporter extends SwfPackerTagExporter
{
    public function new()
    {
        super(ExporerTypes.REMOVE_OBJECT);
    }
    
    override public function exportTag(tag:SwfPackerTag, output:ByteArray):Void
    {
        super.exportTag(tag, output);
        
        var tagAsRemoveObject:SwfPackerTagRemoveObject = Lang.as2(tag, SwfPackerTagRemoveObject);
        
        if (tagAsRemoveObject.depth > 32767 || tagAsRemoveObject.depth < 0) 
            throw new Error("out of range");
        
        output.writeShort(tagAsRemoveObject.depth);
        output.writeShort(tagAsRemoveObject.characterId);
    }
    
    override public function importTag(tag:SwfPackerTag, input:ByteArray):Void
    {
        super.importTag(tag, input);
        
        var tagAsRemoveObject:SwfPackerTagRemoveObject = Lang.as2(tag, SwfPackerTagRemoveObject);
        
        tagAsRemoveObject.depth = input.readShort();
        tagAsRemoveObject.characterId = input.readShort();
    }
}

