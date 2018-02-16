package;

import flixel.FlxSprite;

class Character extends FlxSprite {
    
     public function new(x:Float, y:Float, id:String) {
        super(x, y);

        loadGraphic(id, true, 95, 172);

        var part:Int = Math.round(height * 0.1);

        origin.x = width / 2;
        origin.y = part * 9;

        offset.y = part * 8;
        height   = part * 2;
    }
}
