package swfparser.tags;

import swfdata.DisplayObjectData;
import swfdata.SpriteData;
import swfdata.datatags.SwfPackerTag;
import swfdata.datatags.SwfPackerTagSymbolClass;
import swfparser.SwfParserContext;
import utils.DisplayObjectUtils;
/**
* Тут получаем список ликейджев из библиотеки. Они идут парами characterId, linkageId
*/
class TagProcessorSymbolClassLight extends TagProcessorBase
{
    public function new(context:SwfParserContext)
    {
        super(context);
    }
    
    override public function processTag(tag:SwfPackerTag):Void
    {
        super.processTag(tag);
        
        var tagSymbolClass:SwfPackerTagSymbolClass = Lang.as2(tag, SwfPackerTagSymbolClass);
        var symbolsLength:Int = tagSymbolClass.length;
        
        for (i in 0...symbolsLength)
		{
            var currentLinkage:String = tagSymbolClass.linkageList[i];
            var currentCharacter:Int = tagSymbolClass.characterIdList[i];
            
            var displayObject:DisplayObjectData = context.library.getDisplayObject(currentCharacter);
            
            if (displayObject == null) 
            {
				#if debug
                trace("Error: no symbol for linkage(symbol=" + currentCharacter + ", linkage=" + currentLinkage + ")");
				#end
				continue;
            }
            
            displayObject.libraryLinkage = currentLinkage;
            context.library.addDisplayObjectByLinkage(DisplayObjectUtils.asSpriteData2(displayObject));
        }
    }
}