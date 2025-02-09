package sap.worldmap;

class MapTile extends FlxSprite
{
	override public function new()
	{
		super();

		loadGraphic(FileManager.getImageFile('worldmap/WorldMapTiles'), true, 16, 16);
		animation.add('tile-unplayed', [0]);
		animation.add('tile-finished-port', [1, 2], 6);
		animation.add('tile-finished-sinco', [3, 4], 6);
		animation.add('tile-done-port', [2]);
		animation.add('tile-done-sinco', [4]);
		animation.add('road-repair', [5, 6, 7, 8, 9], 12);
		animation.add('road-broken', [5]);
		animation.add('road', [9]);
		Global.scaleSprite(this);
	}
}
