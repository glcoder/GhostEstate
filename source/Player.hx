package;

import flixel.FlxG;
import flixel.math.FlxMath;

class Player extends Character {
	public var mFearRadius:Float = 200.0;

    public function new(x:Float, y:Float) {
        super(x, y,  AssetPaths.Player__png);

		animation.add("idle", [0, 1], 4, true);

		updateHitbox();

		origin.x = width  / 2;
		origin.y = height - 20;

		offset.x = 20;
		offset.y = 50;
		width    = width  - 40;
		height   = height - 90;

        maxVelocity.x = 300;
        maxVelocity.y = 200;

        drag.x = maxVelocity.x * 10;
        drag.y = maxVelocity.y * 10;
    }

    override public function update(elapsed:Float):Void {
		acceleration.x = acceleration.y = 0;
		
		if (FlxG.keys.anyPressed([LEFT, A])) {
			acceleration.x -= drag.x;
		}

		if (FlxG.keys.anyPressed([RIGHT, D])) {
			acceleration.x += drag.x;
		}

        if (FlxG.keys.anyPressed([UP, W])) {
			acceleration.y -= drag.y;
		}
        
		if (FlxG.keys.anyPressed([DOWN, S])) {
			acceleration.y += drag.y;
		}

		super.update(elapsed);

		if (FlxMath.vectorLength(velocity.x, velocity.y) > 0) {
			animation.play("idle");
		} else {
			animation.pause();
		}
	}
}
