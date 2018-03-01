package swfdata;

/**
* Библиотека символов, шейпы, спрайты и тд по чар идам или линкейджам 
*/
class SymbolsLibrary
{
    var __library:Map<Int, DisplayObjectData> = new Map<Int, DisplayObjectData>();
    var __linkagesLibrary:Map<String, DisplayObjectData> = new Map<String, DisplayObjectData>();
    
    public var shapesList:Array<ShapeData> = new Array<ShapeData>();
    
    public var spritesList:Array<SpriteData> = new Array<SpriteData>();
    public var linkagesList:Array<SpriteData> = new Array<SpriteData>();
    
    public function new()
    {
        
    }
    
    public function clear(callDestroy:Bool = true):Void
    {
        var i:Int;
        
        if (callDestroy) 
        {
            var shapesCount:Int = shapesList.length;
            for (i in 0...shapesCount){
                shapesList[i].destroy();
            }
            
            var spritesCount:Int = spritesList.length;
            for (i in 0...spritesCount){
                spritesList[i].destroy();
            }
            
            var linagesCount:Int = linkagesList.length;
            for (i in 0...linagesCount){
                linkagesList[i].destroy();
            }
            
            for (dObject in __library)
            dObject.destroy();
            
            for (dObject2 in __linkagesLibrary)
            dObject2.destroy();
        }
        
        __library = new Map<Int, DisplayObjectData>();
        __linkagesLibrary = new Map<String, DisplayObjectData>();
        
		shapesList = new Array<ShapeData>();
		spritesList = new Array<SpriteData>();
		linkagesList = new Array<SpriteData>();
    }
    
    public function addDisplayObject(id:Int, displayObject:DisplayObjectData):Void
    {
        if (Std.is(displayObject, ShapeData)) 
            shapesList.push(cast(displayObject, ShapeData));  //	spritesList.push(displayObject);    //if (displayObject is SpriteData)  ;
        
        __library[id] = displayObject;
    }
    
    public function getDisplayObject(characterId:Int):DisplayObjectData
    {
        return __library[characterId];
    }
    
    public function addDisplayObjectByLinkage(displayObject:SpriteData):Void
    {
        //if (displayObject is SpriteData)
        spritesList.push(displayObject);
        
        linkagesList.push(displayObject);
        __linkagesLibrary[displayObject.libraryLinkage] = displayObject;
    }
    
    public function getDisplayObjectByLinkage(libraryLinkage:String):DisplayObjectData
    {
        return Reflect.field(__linkagesLibrary, libraryLinkage);
    }
    
    public function addShapes(shapeLibrary:ShapeLibrary):Void
    {
        for (shapeData/* AS3HX WARNING could not determine type for var: shapeData exp: EField(EIdent(shapeLibrary),shapes) type: null */ in shapeLibrary.shapes)
        {
            addDisplayObject(shapeData.shapeData.characterId.textureId, shapeData.shapeData);
        }
    }
}
