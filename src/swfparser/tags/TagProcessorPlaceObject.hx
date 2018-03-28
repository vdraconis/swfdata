package swfparser.tags;

import openfl.errors.Error;
import openfl.geom.Matrix;
import swfdata.DisplayObjectData;
import swfdata.MovieClipData;
import swfdata.SpriteData;
import swfdata.datatags.SwfPackerTag;
import swfdata.datatags.SwfPackerTagPlaceObject;
import swfparser.SwfParserContext;
import utils.DisplayObjectUtils;
/**
	 * Обрабатывает установку дисплей обжекта в форейм для текущего спрайта
	 * Тут может быть объявлены такие важные вещи как
	 *  - placeMatrix - важно т.к это фактический трансформ и положеине объекта в данном кадре
	 *  - hasMoved - важно т.к если объект не двигался то нужно выставить ему трансформ с последнего зарегестрированого положения этого объекта на таймлайне
	 *  - colorTransform - это просто нужно хранить для корректной визуализации
	 *  - clipping - по клиппингу тут мы определяем какие слои маски, а какие маскируются
	 *  - ratio - рейт морфинга для морф шейпов
	 * 	И другие свойства объектов на таймлайне
	 * 
	 *  Суть в том что теги идут в таком виде
	 * 
	 *  define shape/define sprite     - дефайнятся спрайты и шейпы сначала шейпы которые используются в последующих спрайтах
	 *  define shape/define sprite
	 *  ..........................     - так идет пока не задефайнит все шейпы и спрайты
	 * 	define sprite                  - для объявленого спрайта далее опреедляется его контент, таймлайн, шейпы и т.д
	 *  {
	 *  	define sprite timeline     - далее опередялется таймлайн спрайта идут place/remove обжект теги и show frame. Те объекты что идут один за другим без изменения трансформа или айди должны быть одинаковы. Те что имеют разный трансформ должны быть клонирвоаны
	 *      place object               - ложим объекты текущего кадра
	 *      ......................
	 *      place object
	 *      show frame                 - переходи мна следующий кадр
	 *      ......................
	 *      end    sprite timeline
	 *  }
	 * 
	 *  define class symbol            - в самом конце идут симбол класс метки именно эти объекты нужно будет пост обработать
	 * 
	 *  Суть в том что нужно использовать взеде где можно клоны объектов, а это всгеда когда в кжадом кадре один за другим идут одинаковы объекты с одинаковым контентом
	 */
class TagProcessorPlaceObject extends TagProcessorBase
{
    
    public function new(context:SwfParserContext)
    {
        super(context);
    }
    
    private function getObject(id:Int, tag:SwfPackerTagPlaceObject, preveousTransform:Matrix):DisplayObjectData
    {
        /**
		 * Если в этом кадре ложатся несколько объектов с одинаковым айди но на разные глубины
		 * то нужно для них соотвественно смотреть где есть похожие объекты на таких же глубинах
		 * в предидущих кадрах, и нужно ли их клонировать.
		 */
        
        var isNeedClone:Bool = tag.hasMatrix || tag.hasColorTransform;
        var placedDO:DisplayObjectData;
        var depth:Int = tag.depth;
        
        var placedStorage:Map<Int, DisplayObjectData> = context.placedObjectsById[id];
        
        if (placedStorage == null) 
        {
            placedStorage = new Map<Int, DisplayObjectData>();
			context.placedObjectsById[id] = placedStorage;
        }
        
        if (isNeedClone) 
        {
            placedDO = context.library.getDisplayObject(id).softClone();
        }
        else 
        {
            placedDO = placedStorage[depth];
            
            if (placedDO == null) 
            {
                placedDO = context.library.getDisplayObject(id).softClone();
            }
            
            if (placedDO.transform != preveousTransform) 
                placedDO = placedDO.softClone();
        }
        
        placedStorage[depth] = placedDO;
        
		#if debug
        if (placedDO == null) 
            trace("Дисплей объект не определен в библиотеке символов " + id);
		#end
        
        return placedDO;
    }
    
    private function getObjectFromLibrary(id:Int, hasMatrix:Bool):DisplayObjectData
    {
        var placedDO:DisplayObjectData = null;
        var prototype:DisplayObjectData;
        
        prototype = context.library.getDisplayObject(id);
        
        if (hasMatrix) 
        {
            if (prototype != null) 
                placedDO = prototype.softClone();
			#if debug
            else 
                trace("Дисплей объект не определен в библиотеке символов " + id);
			#end
        }
        else 
        {
            placedDO = prototype;
        }
        
        return placedDO;
    }
    
    inline public function fillFromTag(currentDisplayObject:DisplayObjectData, tag:SwfPackerTagPlaceObject)
    {
        currentDisplayObject.depth = tag.depth;
        
        var isHaveTransform:Bool = currentDisplayObject.transform != null;
        
        if (tag.hasMatrix) 
        {
			#if debug
            if (isHaveTransform) 
                trace("##### HAVE MATRIX ALREADY");
            #end
			
            currentDisplayObject.setTransformMatrix(new Matrix(tag.a, tag.b, tag.c, tag.d, tag.tx, tag.ty));
        }
        else 
        {
            var preveousFrameDO:DisplayObjectData = context.placeObjectsMap[tag.depth];
            currentDisplayObject.setTransformMatrix(preveousFrameDO.transform);
        }
        
        if (tag.hasColorTransform) 
        {
            currentDisplayObject.setColorData(tag.redMultiplier, tag.greenMultiplier, tag.blueMultiplier, tag.alphaMultiplier, tag.redAdd, tag.greenAdd, tag.blueAdd, tag.alphaAdd);
        }
        
        if (tag.hasName) 
            currentDisplayObject.name = tag.instanceName;
			
		// TODO вот это странное место, но если не проверять на уже установленный, то затирается в 0, что делать, если это реально нужно?
		if(currentDisplayObject.blendMode == 0 || tag.blendMode != 0)
			currentDisplayObject.blendMode = tag.blendMode;
        
        currentDisplayObject.hasMoved = tag.hasMove;
    }
    
    override public function processTag(tag:SwfPackerTag)
    {
        super.processTag(tag);
        
        var tagPlaceObject:SwfPackerTagPlaceObject = Lang.as2(tag, SwfPackerTagPlaceObject);
        var currentDisplayObject:SpriteData = Lang.as2(displayObjectContext.currentDisplayObject, SpriteData);
        
        if (currentDisplayObject == null) 
            return;  //probably main time line  ;
        
        var placedDO:DisplayObjectData = null;
        
        var doAsMovieClip:MovieClipData = DisplayObjectUtils.asMovieClip2(currentDisplayObject);
			
        var hasMatrix = tagPlaceObject.hasMatrix;
		var hasColorTransform = tagPlaceObject.hasColorTransform;
		var hasBlendMode = tagPlaceObject.hasBlendMode;
		var isNeedClone = hasMatrix || hasColorTransform || hasBlendMode;
		
        var preveousFrameDO:DisplayObjectData;
        
        if (tagPlaceObject.placeMode == SwfPackerTagPlaceObject.PLACE_MODE_PLACE) 
        {
			//положили объект в таймлайн в первый раз скорее всего поэтому тут поидеи есть чарактер айди и можно взять его из библиотеки
			//placedDO = getObjectFromLibrary(tagPlaceObject.characterId, isNeedClone);
			//Вот тут в оригинале не клонировалось, если была колорматрица, нужно ли клонировать с блендом?
            placedDO = getObjectFromLibrary(tagPlaceObject.characterId, isNeedClone);
            
            if (placedDO == null)//но его там может не быть т.к морфы не парсятся к примеру  
				return;
            
            fillFromTag(placedDO, tagPlaceObject);
            
            if (context.placeObjectsMap[placedDO.depth] != placedDO) 
            {
                context.placeObjectsMap[placedDO.depth] = placedDO;
            }
        }
        else if (tagPlaceObject.placeMode == SwfPackerTagPlaceObject.PLACE_MODE_REPLACE) 
        {
            preveousFrameDO = context.placeObjectsMap[tagPlaceObject.depth];
            
            if (preveousFrameDO == null)//не положили его в плейсинге т.к не было в библиотеке  
            {
				#if debug
                trace("placing error");
				#end
                return;
            }
            
            placedDO = getObject(tagPlaceObject.characterId, tagPlaceObject, preveousFrameDO.transform);
            fillFromTag(placedDO, tagPlaceObject);
            
            if (!hasMatrix) 
            {
                placedDO.setTransformMatrix(preveousFrameDO.transform);
            }
            
			if (!hasBlendMode)
			{
				placedDO.blendMode = preveousFrameDO.blendMode;
			}
			
            if (context.placeObjectsMap[placedDO.depth] != placedDO) 
            {
                context.placeObjectsMap[placedDO.depth] = placedDO;
            }
        }
        else if (tagPlaceObject.placeMode == SwfPackerTagPlaceObject.PLACE_MODE_MOVE) 
        {
            preveousFrameDO = context.placeObjectsMap[tagPlaceObject.depth];
            
            if (preveousFrameDO == null)//не положили его в плейсинге т.к не было в библиотеке  
            {
				#if debug
                trace("placing error");
				#end
                return;
            }
            
            if (isNeedClone) 
            {
                placedDO = preveousFrameDO.softClone();
                fillFromTag(placedDO, tagPlaceObject);
            }
            else 
            {
                placedDO = preveousFrameDO;
            }
            
            if (context.placeObjectsMap[placedDO.depth] != placedDO) 
            {
                context.placeObjectsMap[placedDO.depth] = placedDO;
            }
        }
        else 
			throw new Error("unkwnown place mode");
        
        if (placedDO != null) 
        {
            if (placedDO.transform == null) 
            {
                placedDO.setTransformMatrix(new Matrix());
            }
            
            placedDO.hasPlaced = true;
        }  //currentDisplayObject.depth = tag.clipDepth;    //}    //	currentDisplayObject.addMask(placedDO);    //	placedDO.maskData.maskId = tagPlaceObject.clipDepth;    //	placedDO.maskData.isMask = true;    //{    //if (tagPlaceObject.hasClipDepth)  
        
        if (tagPlaceObject.hasClipDepth) 
        {
            placedDO.isMask = true;
            placedDO.clipDepth = tagPlaceObject.clipDepth;
        }  //currentDisplayObject.getLayerByDepth(tagPlaceObject.depth).setClipAndDepthData(tagPlaceObject.hasClipDepth, tagPlaceObject.clipDepth);    //}    //	placedDO.isMask = tagPlaceObject.hasClipDepth;    //	trace('set do mask status', tagPlaceObject.hasClipDepth);    //{    //if (!placedDO.isMask)  
    }
}