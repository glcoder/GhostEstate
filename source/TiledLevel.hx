package;

import haxe.io.Path;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledImageLayer;

class TiledLevel extends TiledMap {
    private inline static var c_TILESHEETS_PATH = "assets/images/";
    public var mTiles:FlxGroup;
    public var mObjects:FlxGroup;
    public var mBorders:FlxTilemap;
    public var mWalls:FlxTilemap;
    public var mFloor:FlxTilemap;
    public var mPlayerPosition:FlxPoint;
    public var mBossPosition:FlxPoint;
    public var mHumanPositions:Array<SpawnRect>;
    public var mImages:FlxGroup;

    public function new(level:Dynamic, state:GameState) {
		super(level);
		
		mTiles   = new FlxGroup();
		mObjects = new FlxGroup();
        mImages  = new FlxGroup();
		mBorders = new FlxTilemap();
        mWalls   = new FlxTilemap();
        mFloor   = new FlxTilemap();

        mPlayerPosition = new FlxPoint();
        mBossPosition   = new FlxPoint();
        mHumanPositions = new Array<SpawnRect>();
		
		FlxG.camera.setScrollBoundsRect(0, 0, fullWidth, fullHeight, true);

        for (layer in layers) {
            var layerType:String = layer.properties.get("type");
            if (layerType == null)
                continue;

            if (layerType == "tiles") {
                mTiles.add(processTilemap(layer));
            } else if (layerType == "borders") {
                mBorders = processTilemap(layer);
            } else if (layerType == "walls") {
                mWalls = processTilemap(layer);
            } else if (layerType == "floor") {
                mFloor = processTilemap(layer);
            } else if (layerType == "objects") {
                processObjects(layer);
            } else if (layerType == "image") {
                mImages.add(processImage(layer));
            } else {
                throw "Unknown layer type " + layerType;
            }
        }

        state.add(mTiles);
        state.add(mImages);
	}

    private function processObjects(layer:TiledLayer):Void {
        if (layer.type != TiledLayerType.OBJECT) {
            throw "Layer is not a TiledTileLayer";
            return;
        }

        //var tileSet:TiledTileSet = getLayerTileSet(layer);

        var objectLayer:TiledObjectLayer = cast layer;
        for (obj in objectLayer.objects) {
            if (obj.type == "player") {
                mPlayerPosition.set(obj.x, obj.y);
            } else if(obj.type == "boss") {
                mBossPosition.set(obj.x, obj.y);
            } else if (obj.type == "human") {
                mHumanPositions.push(new SpawnRect(obj));
            } else /* if (obj.objectType == TILE) */ {
                // TODO
            }
        }
    }

    private function getTileSetPath(tileSet:TiledTileSet):String {
        var imagePath:Path = new Path(tileSet.imageSource);
        return c_TILESHEETS_PATH + imagePath.file + "." + imagePath.ext;
    }

    private function getLayerTileSet(layer:TiledLayer):TiledTileSet {
        var tileSetName:String = layer.properties.get("tileset");
        if (tileSetName == null) {
            throw "Layer missing tileset property";
            return null;
        }
        return getTileSet(tileSetName);
    }

    private function processImage(layer:TiledLayer):FlxSprite {
        if (layer.type != TiledLayerType.IMAGE) {
            throw "Layer is not a TiledTileLayer";
            return null;
        }

        var imageLayer:TiledImageLayer = cast layer;
        var imagePath:Path = new Path(imageLayer.imagePath);
        var image:String = c_TILESHEETS_PATH + imagePath.file + "." + imagePath.ext;
        return new FlxSprite(imageLayer.x, imageLayer.y, image);
    }

    private function processTilemap(layer:TiledLayer):FlxTilemap {
        if (layer.type != TiledLayerType.TILE) {
            throw "Layer is not a TiledTileLayer";
            return null;
        }

        var tileSet:TiledTileSet = getLayerTileSet(layer);
        if (tileSet == null) {
            throw "Tileset missing";
            return null;
        }

        var tileLayer:TiledTileLayer = cast layer;

        var tilemap = new FlxTilemap();
        tilemap.loadMapFromArray(
            tileLayer.tileArray, width, height,
            getTileSetPath(tileSet),
            tileSet.tileWidth, tileSet.tileHeight,
            OFF, tileSet.firstGID, 1, 1
        );

        return tilemap;
    }
}
