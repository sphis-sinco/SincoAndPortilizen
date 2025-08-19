package levels;

import flixel.text.FlxText;
import menus.LevelSelect;
import flixel.util.FlxCollision;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;

class Osin extends PausableState
{
	public var levelLength:Int = 20;
	public var levelTiles:FlxTypedGroup<Spr>;

	public var moving:Bool = false;

	public var osin:Spr;
	public var osinsBalls:FlxTypedGroup<Spr>;
	public var sinco:Spr;

	public var tileY:Float = 0;
	public var osinTargX:Float = 0;
	public var enemyAttacking:Bool = false;

	public var endlessMode:Bool = false;

	public var timeStart:Int = 60;
	public var timeLeft:Int = 0;
	public var secondTimer:FlxTimer = new FlxTimer();
	public var timeText:FlxText;

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
		osin.animation.add('attack', [2, 3, 3, 4, 4, 4, 4], 30, false);

		osin.animation.onFinish.add(animName ->
		{
			osin.animation.play('idle');
		});

		osin.animation.play('attack');

		osin.screenCenter();
		osin.x -= osin.width * 2;
		osinTargX = osin.x;

		add(osin);

		osinsBalls = new FlxTypedGroup<Spr>();
		add(osinsBalls);

		sinco = new Spr();
		sinco.loadGraphic(Assets.getImagePath('osin/sinco'), true, 128, 128);
		sinco.animation.add('idle', [0]);
		sinco.animation.add('jump', [1]);
		sinco.animation.add('die', [2]);

		sinco.animation.play('idle');

		sinco.screenCenter();
		sinco.y = tileY - sinco.height + 32;

		add(sinco);

		if (!endlessMode)
		{
			timeLeft = timeStart;

			timeText = new FlxText(0, 0, 0, Std.string(timeLeft), 32);
			timeText.screenCenter();
			add(timeText);

			Global.changeDiscordRPCPresence('Avoiding the Copy-cat', 'Vs Osin (${timeLeft} seconds remain)');

			secondTimer.start(1, timer ->
			{
				timeLeft--;

				timeText.text = Std.string(timeLeft);
				timeText.screenCenter();
				Global.changeDiscordRPCPresence('Avoiding the Copy-cat', 'Vs Osin (${timeLeft} seconds remain)');
			}, timeStart);

			FlxTimer.wait(timeStart, () ->
			{
				Global.switchState(new LevelSelect(true));
				Global.beatLevel(1);
			});
		}
		else
			Global.changeDiscordRPCPresence('Avoiding the Copy-cat', 'Vs Osin');
	}

	override function update(elapsed:Float)
	{
		Global.playMenuMusic();

		super.update(elapsed);

		if (Global.keyJustReleased(SPACE) && !paused && !moving)
		{
			moving = true;

			FlxTween.cancelTweensOf(osin);
			osin.animation.play('idle');
			FlxTween.tween(osin, {x: osinTargX - osin.width * 6}, 1, {
				ease: FlxEase.sineOut,
				onComplete: tween ->
				{
					FlxTween.tween(osin, {x: osinTargX}, 1, {
						ease: FlxEase.sineIn,
						onComplete: tween ->
						{
							enemyAttack();
						}
					});
				}
			});

			sinco.animation.play('jump');

			FlxTween.tween(sinco, {y: sinco.y - sinco.height * 2}, .5, {
				ease: FlxEase.sineOut,
				onComplete: tween ->
				{
					FlxTween.tween(sinco, {y: tileY - sinco.height + 32}, .6, {
						ease: FlxEase.sineIn,
						onComplete: tween ->
						{
							sinco.animation.play('idle');
							moving = false;
						}
					});
				},
				onStart: tween ->
				{
					Global.playSoundEffect('gameplay/jump');
				}
			});

			for (tile in levelTiles)
			{
				FlxTween.tween(tile, {x: tile.x - (tile.width * 6)}, 1, {
					onComplete: tween ->
					{
						if (tile.x <= -(tile.width * 4))
							tile.x += (tile.width * levelLength);
					},
					onUpdate: tween ->
					{
						for (ball in osinsBalls)
							ball.x -= 1;
					}
				});
			}
		}
	}

	public var osinAttackTimer:FlxTimer = new FlxTimer();

	public function enemyAttack()
	{
		if (enemyAttacking)
		{
			osinAttackTimer.cancel();
			enemyActualAttack();

			return;
		}

		enemyAttacking = true;
		osin.animation.play('prep');

		spawnBalls(FlxG.random.int(4, 16));

		osinAttackTimer.start(FlxG.random.float(0.5, 1), timer ->
		{
			enemyActualAttack();
		});
	}

	public function enemyActualAttack()
	{
		enemyAttacking = false;
		osin.animation.play('attack');

		for (ball in osinsBalls)
		{
			FlxTween.tween(ball, {x: sinco.x, y: sinco.y, alpha: 0}, 1, {
				ease: FlxEase.sineOut,
				onUpdate: tween ->
				{
					if (FlxCollision.pixelPerfectCheck(ball, sinco))
						Global.switchState(new LevelSelect());
				},
				onComplete: tween ->
				{
					osinsBalls.members.remove(ball);
					ball.destroy();
				}
			});
		}
	}

	public function spawnBalls(amount = 0)
	{
		var i = amount;
		var extraY = 0.0;
		if (osinsBalls.members.length > 0)
		{
			for (ball in osinsBalls.members)
				if (!(extraY >= ball.y))
					extraY += ball.height;
		}

		var rextraY = extraY;
		var rextraX = 0.0;

		while (i > 0)
		{
			var testicle = new Spr();
			testicle.loadGraphic(Assets.getImagePath('osin/osinAttack'));
			testicle.scaleSpr();
			osinsBalls.add(testicle);

			rextraY = extraY; // + (testicle.height * Std.int((i / 8)));
			// rextraX = -(Std.int((i / 8)) * testicle.width);

			testicle.setPosition(osin.getGraphicMidpoint().x, osin.getGraphicMidpoint().y);

			FlxTween.tween(testicle, {x: ((i + 1) * testicle.width) + (8 * (i + 1)) + rextraX, y: testicle.height * 2 + rextraY}, .25, {
				ease: FlxEase.sineInOut
			});

			i--;
		}
	}
}
