package;

import flixel.FlxG;
import flixel.FlxSprite;

class Bullet extends FlxSprite {
    public function new(x:Float, y:Float) {
        super(x, y);
        
        loadGraphic(AssetPaths.Bullet__png, true);

        animation.add("idle", [0], 1, true);
        animation.add("hit",  [1], 1, true);

        offset.x  = 10;
        offset.y  = 10;
        width    -= 20;
        height   -= 20;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }
}
