package levels;

import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;

class StringQuest extends PausableState
{
	public var levelLength:Int = 22;
	public var levelBlocks:FlxTypedGroup<Spr>;

	public var port:Spr;

	var lastBlockY:Float = 0;

	public var enemiesAttacking:Int = 0;

	public var ogwingedEnemies:FlxTypedGroup<Spr>;
	public var wingedEnemies:FlxTypedGroup<Spr>;

	override function create()
	{
		super.create();

		levelBlocks = new FlxTypedGroup<Spr>();
		add(levelBlocks);

		wingedEnemies = new FlxTypedGroup<Spr>();
		add(wingedEnemies);

		ogwingedEnemies = new FlxTypedGroup<Spr>();

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

			spr.setPosition(getWingedEnemyPos(i).x, getWingedEnemyPos(i).y);

			spr.ID = i;

			ogwingedEnemies.add(spr);
			wingedEnemies.add(spr);
		}

		port = new Spr();
		port.loadGraphic(Assets.getImagePath('string-quest/Port'), true, 64, 64);
		port.animation.add('run', [0, 1, 2, 3], 6, true);
		port.animation.add('jump', [4], 24);
		port.animation.add('double-jump', [6], 24);
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

		if (Global.keyJustReleased(SPACE) && port.animation.name == 'run')
		{
			port.animation.play('jump');

			FlxTween.tween(port, {y: port.y - port.height * 2}, 1, {
				ease: FlxEase.sineOut,
				onComplete: tween ->
				{
					port.animation.play('fall');

					FlxTween.tween(port, {y: lastBlockY - (port.height / 1.25)}, 1, {
						ease: FlxEase.sineIn,
						onComplete: tween ->
						{
							port.animation.play('run');
						}
					});
				}
			});
		}
		else
		{
			if (Global.keyJustReleased(SPACE) && port.animation.name == 'jump')
			{
				port.animation.play('double-jump');

				FlxTween.cancelTweensOf(port);
				FlxTween.tween(port, {y: port.y - port.height * 2}, .25, {
					ease: FlxEase.sineOut,
					onComplete: tween ->
					{
						port.animation.play('fall');

						FlxTween.tween(port, {y: lastBlockY - (port.height / 1.25)}, 2, {
							ease: FlxEase.sineIn,
							onComplete: tween ->
							{
								port.animation.play('run');
							}
						});
					}
				});
			}
		}

		if (FlxG.random.bool(15) && enemiesAttacking <= 2)
		{
			var index = 0;
			var i = 1.1;
			for (wingEnemy in wingedEnemies.members)
			{
				if (FlxG.random.bool(5 * i)
					&& wingEnemy.x == getWingedEnemyPos(wingEnemy.ID).x
					&& wingEnemy.y == getWingedEnemyPos(wingEnemy.ID).y
					&& ((port.animation.name != 'jump' && port.animation.name != 'fall') && FlxG.random.bool(25.0)))
				{
					i -= (i / 4);
					final ogPos:FlxPoint = wingEnemy.getPosition();
					enemiesAttacking++;
					wingEnemy.animation.pause();
					FlxTween.tween(wingEnemy, {x: port.x, y: port.y}, 1.5, {
						ease: FlxEase.sineOut,
						onComplete: tween ->
						{
							wingEnemy.animation.play('flap');
							FlxTween.tween(wingEnemy, {x: ogPos.x, y: ogPos.y}, .5, {
								ease: FlxEase.sineIn,
								onComplete: tween ->
								{
									enemiesAttacking--;
								}
							});
						}
					});
				}
				else
				{
					i *= i;
				}

				index++;
			}
		}

		if (enemiesAttacking < 0)
			enemiesAttacking = 0;
	}

	public function getWingedEnemyPos(i:Int)
	{
		var spr:Spr = new Spr();
		spr.loadGraphic(Assets.getImagePath('string-quest/WingedEnemy'), true, 64, 64);

		spr.animation.add('flap', [0, 1], 6);
		spr.animation.play('flap');

		spr.screenCenter();
		spr.y -= i * (spr.height / 4) + 8;
		spr.x -= ((i * spr.width) / 2) + (spr.width * 2);

		return spr.getPosition();
	}
}
