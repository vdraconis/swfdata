package swfparser;

import swfdata.datatags.SwfPackerTag;
import swfparser.SwfParserContext;

interface ISWFDataParser
{
    var context(get, set):SwfParserContext;
    function processDisplayObject(tags:Array<SwfPackerTag>):Void;
}