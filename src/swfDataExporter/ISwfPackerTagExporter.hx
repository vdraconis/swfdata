package swfdataexporter;

import openfl.utils.ByteArray;
import swfdata.datatags.SwfPackerTag;

interface ISwfPackerTagExporter
{
    function exportTag(tag:SwfPackerTag, output:ByteArray):Void;
    function importTag(tag:SwfPackerTag, input:ByteArray):Void;
}