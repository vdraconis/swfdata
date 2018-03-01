package swfdata;

import swfdata.ShapeLibraryItem;

class ShapeLibrary
{
    public var shapes:Map<Int, ShapeLibraryItem> = new Map<Int, ShapeLibraryItem>();
    public var numShapes:Int = 0;
    
    public function new()
    {
		
    }
    
    public function clear(callDestroy:Bool = true):Void
    {
        numShapes = 0;
        if (callDestroy) 
        {
            for (shapeLibraryItem/* AS3HX WARNING could not determine type for var: shapeLibraryItem exp: EIdent(shapes) type: Dynamic */ in shapes)
            {
                shapeLibraryItem.clear();
            }
        }
        
        shapes = new Map<Int, ShapeLibraryItem>();
    }
	
	public function addShape(/*sahpe:Dynamic,*/ shapeData:ShapeData):Void
	{
		numShapes++;
			
		if (shapes.exists(shapeData.characterId))
			return;
			
		var shapeLibraryItem:ShapeLibraryItem = new ShapeLibraryItem();
		//shapeLibraryItem.shape = shape;
		shapeLibraryItem.shapeData = shapeData;
		
		shapes.set(shapeData.characterId.textureId, shapeLibraryItem);
	}
    
    public function getShape(id:Int):ShapeLibraryItem
    {
        return shapes[id];
    }
}