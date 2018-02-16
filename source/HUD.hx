package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

class HUD extends FlxTypedGroup<FlxSprite> {

    private var mProgress:FlxSprite;
    private var mSlider:FlxSprite;
    private var mProgressText:FlxText;

    public function new() {
        super();

        var background:FlxSprite = new FlxSprite(0, FlxG.height - 100);
        background.makeGraphic(FlxG.width, 100, FlxColor.fromInt(0xFF292A2F));
        FlxSpriteUtil.drawRect(background, 0, 0, FlxG.width, 3, FlxColor.fromInt(0xFF35333A));
        FlxSpriteUtil.drawRect(background, 0, 0, FlxG.width, 1, FlxColor.BLACK);

        mProgress = new FlxSprite();
        mProgress.loadGraphic(AssetPaths.Progress__png, false);
        mProgress.setPosition(FlxG.width / 2 - mProgress.width / 2, FlxG.height - 50 - mProgress.height / 2);

        mSlider = new FlxSprite();
        mSlider.loadGraphic(AssetPaths.Slider__png, false);
        mSlider.setPosition(mProgress.x + 15, mProgress.y);

        FlxTween.tween(mSlider, { x:  mProgress.x + 390 }, 60.0, { onUpdate: onUpdate, onComplete: onComplete, type: FlxTween.ONESHOT });

        mProgressText = new FlxText(mProgress.x + 440, mProgress.y + 55, 0, "0%", 16);
        mProgressText.color = FlxColor.fromInt(0xFF84F28E);

        add(background);
        add(mProgress);
        add(mSlider);
        add(mProgressText);

        forEach(function(spr:FlxSprite){spr.scrollFactor.set(0, 0);});
    }

    private function onUpdate(tween:FlxTween):Void {
        //mProgressText.text = Std.string(Math.round(60 - 60 * tween.percent));
        //mProgressText.setPosition(mSlider.x + 10, mSlider.y + mSlider.height);
    }

    private function onComplete(tween:FlxTween):Void {
        GameState.spawnBoss();
    }

    override public function update(elapsed:Float):Void {
        mProgressText.text = Std.string(GameState.mScore) + "%";
        super.update(elapsed);
    }
}
