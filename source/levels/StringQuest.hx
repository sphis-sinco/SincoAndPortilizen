package levels;

import flixel.text.FlxText;
import flixel.util.FlxCollision;
import flixel.util.FlxTimer;
import menus.LevelSelect;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;

class StringQuest extends PausableState
{
	public var levelLength:Int = #if MOBILE_BUILD 44 #else 22 #end;
	public var levelBlocks:FlxTypedGroup<Spr>;

	public var port:Spr;

	var lastBlockY:Float = 0;

	public var enemiesAttacking:Int = 0;

	public var ogwingedEnemies:FlxTypedGroup<Spr>;
	public var wingedEnemies:FlxTypedGroup<Spr>;

	public var endlessMode:Bool = false;

	public var timeStart:Int = 60;
	public var timeLeft:Int = 0;

	public var secondTimer:FlxTimer = new FlxTimer();

	public var timeText:FlxText;

	public function death()
	{
		Global.switchState(new LevelSelect());
		Global.playSoundEffect('gameplay/dead');
	}

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

			final increaseHeightValue = #if MOBILE_BUILD 1 #else 10 #end;

			spr.y = FlxG.height - spr.height;
			if (i > increaseHeightValue)
				spr.y -= spr.height;
			spr.x = spr.width * (i - ((i > increaseHeightValue) ? 11 : 0));

			lastBlockY = spr.y;

			levelBlocks.add(spr);
		}

		for (i in 0...#if MOBILE_BUILD 10 #else 5 #end)
		{
			var spr:Spr = new Spr();
			spr.loadGraphic(Assets.getImagePath('string-quest/WingedEnemy'), true, 64, 64);

			spr.animation.add('flap', [0, 1], 6);
			spr.animation.play('flap');

			spr.setPosition(getWingedEnemyPos(i).x, getWingedEnemyPos(i).y);

			spr.ID = i;

			spr.updateHitbox();

			ogwingedEnemies.add(spr);
			wingedEnemies.add(spr);
		}

		port = new Spr();
		port.loadGraphic(Assets.getImagePath('string-quest/Port'), true, 64, 64);
		port.animation.add('run', [0, 1, 2, 3], 6, true);
		port.animation.add('jump', [4], 24);
		port.animation.add('double-jump', [6], 24);
		port.animation.add('fall', [5], 24);
		port.animation.add('skid', [7], 24);
		port.animation.play('run');

		port.screenCenter(X);
		port.x += port.width * 2;
		portMaxX = port.x;
		port.y = lastBlockY - (port.height / 1.25);
		port.updateHitbox();
		add(port);

		// FlxG.sound.music.stop();

		if (!endlessMode)
		{
			timeLeft = timeStart;

			timeText = new FlxText(0, 0, 0, Std.string(timeLeft), 32);
			timeText.screenCenter();
			add(timeText);

			Global.changeDiscordRPCPresence('Fighting the Winged Enemies', 'String Quest (${timeLeft} seconds remain)');

			secondTimer.start(1, timer ->
			{
				timeLeft--;

				timeText.text = Std.string(timeLeft);
				timeText.screenCenter();
				Global.changeDiscordRPCPresence('Fighting the Winged Enemies', 'String Quest (${timeLeft} seconds remain)');
			}, timeStart);

			FlxTimer.wait(timeStart, () ->
			{
				Global.beatLevel('string-quest');
				Global.switchState(new LevelSelect(true));
			});
		}
		else
			Global.changeDiscordRPCPresence('Fighting the Winged Enemies', 'String Quest');

		add(behindPauseButtonLayer);
		#if MOBILE_BUILD
		add(pauseButton);
		#end
	}

	var portMaxX:Float = 0;

	override function update(elapsed:Float)
	{
		Global.playMenuMusic();

		super.update(elapsed);

		for (block in levelBlocks)
		{
			if (paused)
				return;

			block.x -= 8;

			if (block.x <= -block.width)
				block.x = FlxG.width;
		}

		if (Global.keyPressed(LEFT) || (FlxG.mouse.x < port.x && FlxG.mouse.pressed))
		{
			port.x -= 8;

			if (port.x < (port.width * 4))
				port.x = port.width * 4;
		}
		else if (Global.keyPressed(RIGHT) || (FlxG.mouse.x > port.x && FlxG.mouse.pressed))
		{
			port.x += 8;

			if (port.x > portMaxX)
				port.x = portMaxX;
		}

		if ((Global.keyJustReleased(SPACE)) && port.animation.name == 'run')
			jump();
		else if ((Global.keyJustReleased(SPACE)) && port.animation.name == 'jump')
			doubleJump();

		if (!paused && FlxG.random.bool(15) && enemiesAttacking < #if MOBILE_BUILD 6 #else 2 #end)
		{
			var index = 0;
			var i = 1.1;
			for (wingEnemy in wingedEnemies.members)
			{
				if (FlxG.random.bool(5 * i)
					&& wingEnemy.x == getWingedEnemyPos(wingEnemy.ID).x
					&& wingEnemy.y == getWingedEnemyPos(wingEnemy.ID).y
					&& FlxG.random.bool(10.0))
				{
					i -= (i / 4);
					enemyAttack(wingEnemy);
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

	override function togglePaused()
	{
		if (timeLeft < 1 && !paused)
			return;

		super.togglePaused();

		for (wingEnemy in wingedEnemies.members)
			wingEnemy.animation.paused = paused;
		port.animation.paused = paused;
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

	public function enemyAttack(wingEnemy:Spr)
	{
		final ogPos:FlxPoint = wingEnemy.getPosition();
		enemiesAttacking++;
		// wingEnemy.animation.pause();
		FlxTween.tween(wingEnemy, {x: port.x, y: port.y}, 1, {
			onComplete: tween ->
			{
				wingEnemy.animation.play('flap');
				FlxTween.tween(wingEnemy, {x: ogPos.x, y: ogPos.y}, .5, {
					onComplete: tween ->
					{
						enemiesAttacking--;
					},
					onUpdate: tween ->
					{
						if (FlxCollision.pixelPerfectCheck(wingEnemy, port))
							death();
					}
				});
			},
			onUpdate: tween ->
			{
				if (FlxCollision.pixelPerfectCheck(wingEnemy, port))
					death();
			}
		});
	}

	public function jump()
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
			},
			onStart: tween ->
			{
				Global.playSoundEffect('gameplay/jump');
			}
		});
	}

	public function doubleJump()
	{
		return;

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
