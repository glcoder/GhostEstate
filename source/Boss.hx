package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup;

private enum State {
    ROAMING;
    CASTING;
}

class Boss extends Character {
    private var mState:State = ROAMING;
    private var mRoamingDirection:FlxPoint = new FlxPoint();
    private var mRoamingSpeed:Float = 120;
    private var mRoamingTimer:FlxTimer = new FlxTimer();
    private var mCastingTimer:FlxTimer = new FlxTimer();
    public var mBullets:FlxTypedGroup<Bullet> = new FlxTypedGroup<Bullet>();

    public function new(x:Float, y:Float) {
        super(x, y, AssetPaths.Boss__png);

        animation.add("idle", [0], 1, true);
        animation.add("walk", [1, 2], 4, true);
        animation.add("cast", [3, 4], 4, true);

        drag.set(100, 100);
        //immovable = true;
    }

    public function init(x:Float, y:Float) {
        reset(x, y);
        onRoamingTimer(mRoamingTimer);

        alpha  = 1.0;
        mState = ROAMING;
    }

    private function onRoamingTimer(timer:FlxTimer):Void {
        timer.active = false;

        var angle:Float = FlxG.random.float(0, 2.0 * Math.PI);
        mRoamingDirection.set(
            Math.cos(angle) * mRoamingSpeed,
            Math.sin(angle) * mRoamingSpeed
        );

        if (FlxG.random.float() > 0.5) {
            mState = CASTING;
            mCastingTimer.start(1, onCastingTimer, 1);
        } else {
            mRoamingTimer.start(FlxG.random.float(1, 3), onRoamingTimer, 1);
        }
    }

    private function onCastingTimer(timer:FlxTimer):Void {
        timer.active = false;

        // TODO CAST
        var count:Int = 16;
        for (i in 0 ... count) {
            var angle:Float = 2.0 * Math.PI / count * i;
            var X:Float = x + 70  + 50 * Math.cos(angle);
            var Y:Float = y - 140 + 50 * Math.sin(angle);
            var bullet:Bullet = mBullets.recycle(Bullet.new.bind(X, Y));
            bullet.reset(X, Y);
            bullet.velocity.set(200.0 * Math.cos(angle), 200.0 * Math.sin(angle));
        }

        mState = ROAMING;
        onRoamingTimer(mRoamingTimer);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        switch (mState) {
            case ROAMING:
                animation.play(FlxMath.vectorLength(velocity.x, velocity.y) > 0 ? "walk" : "idle");
                velocity.x = mRoamingDirection.x;
                velocity.y = mRoamingDirection.y;
            case CASTING:
                animation.play("cast");
                velocity.x = 0;
                velocity.y = 0;
        }
    }
}