package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

private enum State {
    ROAMING;
    RUNNING;
    DYING;
}

class Human extends Character {

    private var mState:State = ROAMING;
    private var mRoamingDirection:FlxPoint = new FlxPoint();
    private var mRoamingSpeed:Float = 60;
    private var mRoamingTimer:FlxTimer = new FlxTimer();
    public var mSpawnRect:SpawnRect;
    public var mFearLevel:Float = 0.0;

    public function new(rect:SpawnRect, x:Float, y:Float, id:String) {
        super(x, y, id);

        mSpawnRect = rect;

        animation.add("idle_normal", [0], 1, true);
        animation.add("idle_scared", [1], 1, true);
        animation.add("walk_normal", [2, 3], 4, true);
        animation.add("walk_scared", [4, 5], 4, true);

        drag.set(100, 100);
    }

    public function init(x:Float, y:Float) {
        reset(x, y);
        onRoamingTimer(mRoamingTimer);

        alpha      = 1.0;
        mState     = ROAMING;
        mFearLevel = 0.0;
    }

    private function onRoamingTimer(timer:FlxTimer):Void {
        var angle:Float = FlxG.random.float(0, 2.0 * Math.PI);
        mRoamingDirection.set(
            Math.cos(angle) * mRoamingSpeed,
            Math.sin(angle) * mRoamingSpeed
        );

        mRoamingTimer.start(FlxG.random.float(1, 3), onRoamingTimer, 1);
    }

    private function isPlayerNearby(scared:Bool):Bool {
        return FlxMath.distanceBetween(this, GameState.mPlayer) < (GameState.mPlayer.mFearRadius * (scared ? 2.0 : 1.0));
    }

    override public function update(elapsed:Float):Void {
        var scared:Bool = mFearLevel > 0.5;
        var dying:Bool  = mFearLevel >= 1.0;
        var nearby:Bool = isPlayerNearby(scared);

        maxVelocity.x = scared ? 200 : 150;
        maxVelocity.y = scared ? 200 : 150;

        switch (mState) {
            case ROAMING:
                mState = nearby ? RUNNING : ROAMING;
                velocity.x = mRoamingDirection.x;
                velocity.y = mRoamingDirection.y;
            case RUNNING:
                mState = nearby ? RUNNING : ROAMING;
                mFearLevel = FlxMath.bound(mFearLevel + elapsed * 0.1 *  (nearby ? 1 : -1), 0, 1);
                moveOutwardsObject(this, GameState.mPlayer, scared ? 120 : 60);
                if (dying) {
                    mState = DYING;
                    GameState.mScore += 5;
                    FlxTween.tween(this, { alpha: 0.0 }, 1.0, { onComplete: onComplete, type: FlxTween.ONESHOT });
                }
            case DYING:
                // nothing
        }

		super.update(elapsed);

        if (FlxMath.vectorLength(velocity.x, velocity.y) > 0) {
			animation.play("walk_"  + (scared ? "scared" : "normal"));
		} else {
			animation.play("idle_" + (scared ? "scared" : "normal"));
		}
	}
    
    private function onComplete(tween:FlxTween):Void {
        kill();
        mRoamingTimer.active = false;
        GameState.spawnHuman(mSpawnRect);
    }

    public static function moveOutwardsObject(Source:FlxSprite, Dest:FlxSprite, Speed:Float = 60):Void {
		var a:Float = FlxAngle.angleBetween(Source, Dest);
		Source.velocity.x = -Math.cos(a) * Speed;
		Source.velocity.y = -Math.sin(a) * Speed;
	}
}
