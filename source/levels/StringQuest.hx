package levels;

import flixel.group.FlxGroup.FlxTypedGroup;

class StringQuest extends PausableState
{
	public var levelLength:Int = 22;
	public var levelBlocks:FlxTypedGroup<Spr>;

	public var port:Spr;

	public var wingedEnemies:FlxTypedGroup<Spr>;

	override function create()
	{
		super.create();

		levelBlocks = new FlxTypedGroup<Spr>();
		add(levelBlocks);

		wingedEnemies = new FlxTypedGroup<Spr>();
		add(wingedEnemies);

		var lastBlockY:Float = 0;
		for (i in 0...levelLength)
		{
			var spr:Spr = new Spr();
			spr.loadGraphic(Assets.getImagePath('string-quest/block'));

			spr.y = FlxG.height - spr.height;
			if (i > 10)
				spr.y -= spr.height;
			spr.x = spr.width * (i - ((i > 10) ? 11 : 0));

			lastBlockY = spr.y;

			levelBlocks.add(spr);
		}

		for (i in 0...5)
		{
			var spr:Spr = new Spr();
			spr.loadGraphic(Assets.getImagePath('string-quest/WingedEnemy'), true, 64, 64);

			spr.animation.add('flap', [0, 1], 6);
			spr.animation.play('flap');

			spr.screenCenter();
			spr.y -= i * (spr.height / 4) + 8;
			spr.x -= i * spr.width + 8;

			wingedEnemies.add(spr);
		}

		port = new Spr();
		port.loadGraphic(Assets.getImagePath('string-quest/Port'), true, 64, 64);
		port.animation.add('run', [0, 1, 2, 3], 6, true);
		port.animation.add('jump', [4], 24);
		port.animation.add('fall', [5], 24);
		port.animation.play('run');

		port.screenCenter(X);
		port.x += port.width * 2;
		port.y = lastBlockY - (port.height / 1.25);
		add(port);

		FlxG.sound.music.stop();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		for (block in levelBlocks)
		{
			block.x -= 8;

			if (block.x <= -block.width)
				block.x = FlxG.width;
		}
	}
}
