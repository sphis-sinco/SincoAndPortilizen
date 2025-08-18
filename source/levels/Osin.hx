package levels;

import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;

class Osin extends PausableState
{
	public var levelLength:Int = 11;
	public var levelTiles:FlxTypedGroup<Spr>;

	public var moving:Bool = false;

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

		if (Global.keyJustReleased(SPACE) && !paused && !moving)
		{
			moving = true;
			for (tile in levelTiles)
			{
				FlxTween.tween(tile, {x: tile.x - tile.width}, 1, {
					onComplete: tween ->
					{
						if (tile.x <= -tile.width)
							tile.x = FlxG.width;

						if (levelTiles.members[levelTiles.members.length - 1] == tile)
							moving = false;
					}
				});
			}
		}
	}
}
