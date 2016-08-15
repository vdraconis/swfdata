package swfdata;

import swfdata.LayerData;

import flash.geom.Matrix;

class FrameObjectData
{
    public var depth : Int;
    public var characterId : Int;
    public var className : String;
    public var placedAtIndex : Int;
    public var lastModifiedAtIndex : Int;
    public var isKeyframe : Bool;
    public var layer : LayerData;
    
    public function new(depth : Int, characterId : Int, className : String, placedAtIndex : Int, lastModifiedAtIndex : Int, isKeyframe : Bool)
    {
        this.isKeyframe = isKeyframe;
        this.lastModifiedAtIndex = lastModifiedAtIndex;
        this.placedAtIndex = placedAtIndex;
        this.className = className;
        this.characterId = characterId;
        this.depth = depth;
    }
}
