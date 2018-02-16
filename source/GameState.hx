package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxSort;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.math.FlxMath;
import flixel.group.FlxGroup;

class GameState extends FlxState {

    private static var LEVELS:Array<String> = [
        AssetPaths.main_level_01_hacks__tmx,
        AssetPaths.main_level_02__tmx,
        AssetPaths.main_level_03__tmx
    ];

    public static var mLevelIndex:Int = 0;

    public static var mLevel:TiledLevel;
    public static var mPlayer:Player;
    public static var mBoss:Boss;
    public static var mHumans:FlxTypedGroup<Human>;

    public static var mPlayerCollision:FlxGroup;
    public static var mHumansCollision:FlxGroup;
    public static var mScore:Int;
    public static var mHUD:HUD;

    override public function create():Void {
		super.create();

        FlxG.cameras.bgColor = FlxColor.fromInt(0xFF292A2F);

        #if FLX_MOUSE
        FlxG.mouse.visible = false;
        #end

        init();
	}

    public function init() {
        loadLevel(LEVELS[mLevelIndex]);
        FlxG.camera.fade(FlxColor.BLACK, 2.0, true);
    }

    public function loadLevel(level:String):Void {
        clear();

        mScore = 0;

        mLevel  = new TiledLevel(level, this);
		mPlayer = new Player(mLevel.mPlayerPosition.x, mLevel.mPlayerPosition.y);
        mBoss   = new Boss(mLevel.mPlayerPosition.x, mLevel.mPlayerPosition.y);
        mHumans = new FlxTypedGroup<Human>();
        mHUD    = new HUD();

        mBoss.kill();

        FlxG.camera.follow(mPlayer, TOPDOWN, 1);

        for (rect in mLevel.mHumanPositions) {
            for (i in 0 ... rect.mCount)
                spawnHuman(rect);
        }

        mPlayerCollision = new FlxGroup();
        mPlayerCollision.add(mLevel.mBorders);

        mHumansCollision = new FlxGroup();
        mHumansCollision.add(mBoss);
        mHumansCollision.add(mHumans);
        mHumansCollision.add(mLevel.mWalls);
        mHumansCollision.add(mLevel.mBorders);

        add(mHumans);
        add(mBoss);
        add(mBoss.mBullets);
        add(mPlayer);
        add(mHUD);
    }

    public static function spawnHuman(rect:SpawnRect):Void {
        var point:FlxPoint = new FlxPoint(
            rect.x + FlxG.random.float(0, rect.width),
            rect.y + FlxG.random.float(0, rect.height)
        );

        var types:Array<String> = new Array<String>();
        if (rect.mSpawnGirl) {
            types.push(AssetPaths.Girl_1__png);
            types.push(AssetPaths.Girl_2__png);
            types.push(AssetPaths.Girl_3__png);
        }
        if (rect.mSpawnMan) {
            types.push(AssetPaths.Man_1__png);
            types.push(AssetPaths.Man_2__png);
            types.push(AssetPaths.Man_3__png);
        }
        if (rect.mSpawnProfessor) {
            types.push(AssetPaths.Professor_1__png);
            types.push(AssetPaths.Professor_2__png);
            types.push(AssetPaths.Professor_3__png);
        }

        var human:Human = mHumans.recycle(Human.new.bind(rect, point.x, point.y, FlxG.random.getObject(types)));
        human.init(point.x, point.y);
    }

    public static function spawnBoss():Void {
        GameState.mBoss.init(GameState.mLevel.mPlayerPosition.x, GameState.mLevel.mPlayerPosition.y);
        //GameState.mBoss = new Boss(GameState.mLevel.mPlayerPosition.x, GameState.mLevel.mPlayerPosition.y);
    }

	override public function update(elapsed:Float):Void {
        super.update(elapsed);
        
        FlxG.collide(mHumansCollision, mHumans);
        FlxG.collide(mHumansCollision, mBoss);
        FlxG.collide(mPlayerCollision, mPlayer);
        
        mHumans.sort(FlxSort.byY);

        FlxG.overlap(mBoss.mBullets, mPlayer, onHit);

        if (mScore >= 100) {
            FlxG.camera.fade(FlxColor.BLACK, 2.0, false, OnWin);
        }
	}

    private function onHit(bullet:Bullet, player:Player):Void {
        bullet.animation.play("hit");
        FlxG.camera.shake();
        FlxG.camera.fade(FlxColor.BLACK, 2.0, false, OnLose);
    }

    private function OnWin():Void {
        ++mLevelIndex;
        clear();

        /*var win:FlxSprite = new FlxSprite();
        win.loadGraphic(AssetPaths.YouWin__png);
        win.x = FlxG.width / 2  - win.width / 2;
        win.y = FlxG.height / 2 - win.height / 2;
        add(win);*/
    }

    private function OnLose():Void {
        clear();

        /*var lose:FlxSprite = new FlxSprite();
        lose.loadGraphic(AssetPaths.YouLose__png);
        lose.x = FlxG.width / 2  - lose.width / 2;
        lose.y = FlxG.height / 2 - lose.height / 2;
        add(lose);*/
    }
}
