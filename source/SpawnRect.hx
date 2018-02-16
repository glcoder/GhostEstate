package;

import flixel.math.FlxRect;
import flixel.addons.editors.tiled.TiledObject;

class SpawnRect extends FlxRect {

    public var mCount:Int;
    public var mSpawnGirl:Bool;
    public var mSpawnMan:Bool;
    public var mSpawnProfessor:Bool;

    public function new(obj:TiledObject):Void {
        super(obj.x, obj.y, obj.width, obj.height);
        
        var count:String = obj.properties.get("count");
        mCount = count == null ? 1 : Std.parseInt(count);

        var spawn:String = obj.properties.get("human_type");
        mSpawnGirl      = spawn == null ? true : spawn.toLowerCase().indexOf("g") >= 0;
        mSpawnMan       = spawn == null ? true : spawn.toLowerCase().indexOf("m") >= 0;
        mSpawnProfessor = spawn == null ? true : spawn.toLowerCase().indexOf("p") >= 0;
    }
}
