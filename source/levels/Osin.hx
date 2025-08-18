package levels;

import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;

class Osin extends PausableState
{
	public var levelLength:Int = 12;
	public var levelTiles:FlxTypedGroup<Spr>;

	override function create()
	{
		super.create();

		levelTiles = new FlxTypedGroup<Spr>();
		add(levelTiles);

		for (i in 0...levelLength)
		{
			var spr:Spr = new Spr();
			spr.loadGraphic(Assets.getImagePath('osin/tile'));

			spr.y = FlxG.height - spr.height;
			spr.x = spr.width * i;

			levelTiles.add(spr);
		}
	}

	override function update(elapsed:Float)
	{
		Global.playMenuMusic();

		super.update(elapsed);

		if (Global.keyJustReleased(SPACE) && !paused)
		{
			for (tile in levelTiles)
			{
				FlxTween.tween(tile, {x: tile.x - tile.width}, 1, {
					onComplete: tween ->
					{
						if (tile.x <= -tile.width)
							tile.x = FlxG.width + tile.width;
					}
				});
			}
		}
	}
}
