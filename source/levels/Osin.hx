package levels;

import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;

class Osin extends PausableState
{
	public var levelLength:Int = 11;
	public var levelTiles:FlxTypedGroup<Spr>;

	public var moving:Bool = false;

        public var osin:Spr;
        public var sinco:Spr;

        public var tileY:Float = 0;

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

                        tileY = spr.y;

			levelTiles.add(spr);
		}

                osin = new Spr();
                osin.loadGraphic(Assets.getImagePath('osin/osin'), true, 128, 128);
                osin.animation.add('idle', [0]);
                osin.animation.add('prep', [1]);
                osin.animation.add('attack', [2,3,4], 30, false);

                osin.animation.play('idle');

                osin.screenCenter();
                osin.x -= osin.width * 2;

                add(osin);

                sinco = new Spr();
                sinco.loadGraphic(Assets.getImagePath('osin/sinco'), true, 128, 128);
                sinco.animation.add('idle', [0]);
                sinco.animation.add('jump', [1]);
                sinco.animation.add('die', [2]);

                sinco.animation.play('idle');

                sinco.screenCenter();
                sinco.y = tileY - sinco.height;

                add(sinco);
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
