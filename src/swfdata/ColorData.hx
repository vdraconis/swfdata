package swfdata;



class ColorData
{
    public var a:Float = 1;
    public var r:Float = 1;
    public var g:Float = 1;
    public var b:Float = 1;
    
    public function new(r:Float = 1, g:Float = 1, b:Float = 1, a:Float = 1)
    {
        this.a = a;
        this.b = b;
        this.g = g;
        this.r = r;
    }
    
    public function clear():Void
    {
        a = 1;
        r = 1;
        b = 1;
        g = 1;
    }
    
    public function mulColorData(colorData:ColorData):Void
    {
        //TODO: Поидеи нужно умножать колор на альфу чтобы премультиплайд колор поулчать но пока посомтрим может и не нужно
        //UPD: Хотя вероятно это единственный вариант как комплексному объекту выставить одинаковую прозрачность
        a *= colorData.a;
        r *= colorData.r;
        g *= colorData.g;
        b *= colorData.b;
    }
}
