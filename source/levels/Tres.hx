package levels;

import flixel.math.FlxMath;
import flixel.text.FlxText;
import menus.LevelSelect;
import flixel.util.FlxCollision;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;

class Tres extends PausableState
{
	public var tdm2:Spr;
	public var sinco:Spr;
	public var port:Spr;
	public var instructions:Spr;

	public var sincoSCPos:FlxPoint;
	public var portSCPos:FlxPoint;

	public var sincoRPos:FlxPoint;
	public var portRPos:FlxPoint;

	public var playerPos:FlxPoint;
	public var enemyPos:FlxPoint;

	public var portParticles:FlxTypedGroup<Spr>;

	public var selectedHero:Int = FlxG.random.int(0, 1);

	public var enemyAttacking:Bool = false;
	public var enemyCooldown:Int = 320;
	public var enemyAttacks:FlxTypedGroup<Spr>;

	public var endlessMode:Bool = false;

	public var timeStart:Int = 120;
	public var timeLeft:Int = 0;
	public var secondTimer:FlxTimer = new FlxTimer();
	public var timeText:FlxText;

	override function create()
	{
		super.create();
		add(Global.dummyBG([12, 12, 45]));

		tdm2 = new Spr(#if MOBILE_BUILD 1 #else - 1 #end);
		tdm2.loadGraphic(Assets.getImagePath('tres/TDM2'), true, 320, 204);
		tdm2.animation.add('idle', [0]);
		tdm2.animation.add('attack-pre', [0, 0, 1, 2, 2, 3], 6, false);
		tdm2.animation.add('attack', [4]);
		tdm2.animation.add('attack-post', [4, 4, 5, 6, 6, 7, 0], 15, false);
		tdm2.scaleSpr();
		tdm2.screenCenter();
		tdm2.animation.play('idle');
		enemyPos = new FlxPoint(tdm2.x, tdm2.y);
		add(tdm2);

		portParticles = new FlxTypedGroup<Spr>();
		add(portParticles);

		sinco = new Spr(#if MOBILE_BUILD 4 #else 0 #end);
		sinco.loadGraphic(Assets.getImagePath('tres/superSinco'));
		sinco.screenCenter();
		sincoSCPos = new FlxPoint(sinco.x, sinco.y);
		sinco.x -= (sinco.width * #if MOBILE_BUILD 35 #else 2 #end);
		sinco.y -= sinco.height;
		add(sinco);
		sincoRPos = new FlxPoint(sinco.x, sinco.y);

		port = new Spr(#if MOBILE_BUILD 4 #else 0 #end);
		port.loadGraphic(Assets.getImagePath('tres/superPort'));
		port.screenCenter();
		portSCPos = new FlxPoint(port.x, port.y);
		port.x -= (port.width * #if MOBILE_BUILD 35 #else 3 #end);
		port.y += (port.height * 2);
		add(port);
		portRPos = new FlxPoint(port.x, port.y);

		playerPos = new FlxPoint();

		enemyAttacks = new FlxTypedGroup<Spr>();
		add(enemyAttacks);

		instructions = new Spr();
		instructions.loadGraphic(Assets.getImagePath('tres/swapInstruction'), true, 256, 256);
		instructions.animation.add('animate', [0, 1], 4);
		instructions.animation.play('animate');
		instructions.screenCenter();
		#if !MOBILE_BUILD
		add(instructions);
		#end

		FlxTimer.wait(2, () ->
		{
			FlxTween.tween(instructions, {alpha: 0}, 1, {
				ease: FlxEase.smoothStepInOut,
				onComplete: tween ->
				{
					instructions.destroy();
				}
			});
		});

		if (!endlessMode)
		{
			timeLeft = timeStart;

			timeText = new FlxText(0, 32, 0, Std.string(timeLeft), 32);
			timeText.screenCenter(X);
			add(timeText);

			Global.changeDiscordRPCPresence('Fighting the mad-man', 'Tres (${timeLeft} seconds remain)');

			secondTimer.start(1, timer ->
			{
				timeLeft--;

				timeText.text = Std.string(timeLeft);
				timeText.screenCenter(X);
				Global.changeDiscordRPCPresence('Fighting the mad-man', 'Tres (${timeLeft} seconds remain)');
			}, timeStart);

			FlxTimer.wait(timeStart, () ->
			{
				Global.beatLevel(3);
				Global.switchState(new LevelSelect(true));
			});
		}
		else
			Global.changeDiscordRPCPresence('Fighting the mad-man', 'Tres');

		Global.fadeToMusic('StageTracks/Tres', .25, 1, 1);

		add(behindPauseButtonLayer);
		#if MOBILE_BUILD
		add(pauseButton);
		#end
	}

	final playerSpeed:Float = 10;
	final setPosSpeed:Float = 10;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		tdm2.animation.paused = paused;

		Global.playMusic('StageTracks/Tres');

		if (!paused)
			switch (selectedHero)
			{
				case 0:
					sinco.x += (((sincoSCPos.x + playerPos.x) - sinco.x) / setPosSpeed);
					sinco.y += (((sincoSCPos.y + playerPos.y) - sinco.y) / setPosSpeed);
					port.x += ((portRPos.x - port.x) / setPosSpeed);
					port.y += ((portRPos.y - port.y) / setPosSpeed);
				case 1:
					sinco.x += ((sincoRPos.x - sinco.x) / setPosSpeed);
					sinco.y += ((sincoRPos.y - sinco.y) / setPosSpeed);
					port.x += (((portSCPos.x + playerPos.x) - port.x) / setPosSpeed);
					port.y += (((portSCPos.y + playerPos.y) - port.y) / setPosSpeed);
			}

		if (Global.keyJustReleased(Z) && !paused)
		{
			// playerPos = new FlxPoint();

			selectedHero = (selectedHero == 1) ? 0 : 1;
		}

		if (!paused)
			movementCheck();

		if (FlxG.random.bool(FlxG.random.float(80, 100)) && !paused)
		{
			var particle = new Spr(-3);

			particle.loadGraphic(Assets.getImagePath('tres/superPortParticles'), true, 32, 32);
			particle.animation.add('particles', [0, 1, 2, 3], 0);
			particle.animation.randomFrame();

			particle.scaleSpr();

			particle.setPosition(port.getGraphicMidpoint().x, port.getGraphicMidpoint().y);

			portParticles.add(particle);
		}

		for (particle in portParticles)
		{
			if (paused)
				return;

			particle.x += ((port.getGraphicMidpoint().x - particle.x) / (setPosSpeed / 2));
			particle.y += ((port.getGraphicMidpoint().y - particle.y) / (setPosSpeed / 2));

			particle.x -= FlxG.random.float((particle.height / 10), particle.height * 2);
			particle.y += FlxG.random.float(-(particle.height / 4), particle.height / 4);

			particle.alpha -= (1 / FlxG.random.float(1, 15));

			if (particle.alpha <= 0)
			{
				portParticles.members.remove(particle);
				particle.destroy();
			}
		}

		if (FlxG.random.bool(FlxG.random.float(0, 25)) && enemyCooldown < 1 && !paused)
		{
			if (enemyAttacking)
				return;

			enemyCooldown = FlxG.random.int(160, 320);

			enemyAttacking = true;
			tdm2.animation.play('attack-pre');
			FlxTween.tween(tdm2, {x: tdm2.width / 3}, (1 / 6) * 6, {
				ease: FlxEase.smoothStepInOut,
				onComplete: tween ->
				{
					tdm2.animation.play('attack');
					var ogammoCount:Int = FlxG.random.int(#if MOBILE_BUILD 20, 50 #else 5, 20 #end);
					var ammoCount:Int = ogammoCount;

					while (ammoCount > 0)
					{
						var attack = new Spr(-2);
						attack.loadGraphic(Assets.getImagePath('tres/TDM2Attack'));
						attack.scaleSpr();
						attack.screenCenter();
						attack.x += attack.width * #if MOBILE_BUILD 2.75 #else 3.5 #end;
						attack.y += attack.height * #if MOBILE_BUILD 2 #else 1.5 #end;

						attack.acceleration.x = FlxG.random.int(-200, -80) * 2;
						attack.acceleration.y = FlxG.random.int(-300, 300) * 2;
						attack.moves = false;

						enemyAttacks.add(attack);

						ammoCount--;
					}

					FlxTimer.wait(0.1 * #if MOBILE_BUILD ogammoCount / 2 #else ogammoCount #end, () ->
					{
						FlxTween.tween(tdm2, {x: enemyPos.x});
						tdm2.animation.play('attack-post');
						FlxTimer.wait((1 / 15) * 7, () ->
						{
							tdm2.animation.play('idle');
							enemyAttacking = false;
						});
					});
				}
			});
		}

		if (enemyCooldown > 0)
			enemyCooldown--;

		for (bullet in enemyAttacks)
		{
			if (!paused)
				bullet.updateMotion(elapsed);

			var player = sinco;
			if (selectedHero == 1)
				player = port;

			if (FlxCollision.pixelPerfectCheck(bullet, player))
				Global.switchState(new LevelSelect());

			if (bullet.x < -bullet.width)
			{
				bullet.color = 0xff0000;
				enemyAttacks.members.remove(bullet);
				bullet.destroy();
			}
		}
	}

	public function movementCheck()
	{
		if (Global.anyKeysPressed([LEFT, A]))
			playerPos.x -= playerSpeed;
		if (Global.anyKeysPressed([RIGHT, D]))
			playerPos.x += playerSpeed;
		if (Global.anyKeysPressed([UP, W]))
			playerPos.y -= playerSpeed;
		if (Global.anyKeysPressed([DOWN, S]))
			playerPos.y += playerSpeed;

		#if MOBILE_BUILD
		/** for (swipe in FlxG.swipes)
			{
				final absdeg = Math.abs(Math.floor(swipe.degrees));

				trace(absdeg);

				if (absdeg >= 0 && absdeg < 90 || absdeg > 271 && absdeg <= 260)
					playerPos.x += (playerSpeed + swipe.distance);

				if (absdeg >= 90 && absdeg < 271)
					playerPos.x -= (playerSpeed + swipe.distance);
		} **/

		if (selectedHero == 0)
		{
			playerPos.x = sincoSCPos.x - FlxG.mouse.x;
			playerPos.y = sincoSCPos.y - FlxG.mouse.y;
		}
		else
		{
			playerPos.x = portSCPos.x - FlxG.mouse.x;
			playerPos.y = portSCPos.y - FlxG.mouse.y;
		}
		#end

		var bindLeft = -(FlxG.width / 2);
		var bindUp = -(FlxG.height / 2);
		var bindDown = FlxG.height / 2;
		var bindRight = FlxG.width / 8;

		if (playerPos.x >= bindRight)
			playerPos.x = bindRight;
		if (playerPos.x <= bindLeft)
			playerPos.x = bindLeft;

		if (playerPos.y >= bindDown)
			playerPos.y = bindDown;
		if (playerPos.y <= bindUp)
			playerPos.y = bindUp;
	}
}
