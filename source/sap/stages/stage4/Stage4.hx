package sap.stages.stage4;

import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import sap.worldmap.Worldmap;

class Stage4 extends State
{
	public static var port:PortS4;
	public static var enemy:EnemyS4;

	public static var bg:FlxSprite;

	public static var DISMx2:Float = Global.DEFAULT_IMAGE_SCALE_MULTIPLIER * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER;

	public static var timerText:FlxText;
	public static var time:Int = 0;

	override function create()
	{
		super.create();

		port = new PortS4();
		enemy = new EnemyS4();

		bg = new FlxSprite();
		bg.loadGraphic(FileManager.getImageFile('gameplay/port stages/Stage4BG'));
		Global.scaleSprite(bg);
		bg.screenCenter();
		add(bg);

		port.screenCenter();
		port.x = FlxG.width - port.width * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER * 4;
		add(port);

		enemy.screenCenter();
		enemy.x -= enemy.width * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER;
		enemyX = enemy.x;
		add(enemy);

		port.y = Std.int(FlxG.height - port.height * DISMx2);
		enemy.y = port.y;


                time = 0;
		FlxTimer.wait(StageGlobal.STAGE4_START_TIMER, () ->
		{
			levelComplete();
		});

		timerText = new FlxText(10, 10, 0, "60", 64);
		timerText.screenCenter();
		add(timerText);
		waitSec();

		Global.changeDiscordRPCPresence('Stage 4: Dimensional String', null);
	}

	public static dynamic function levelComplete()
	{
		Global.beatLevel(4);
		FlxG.switchState(() -> new Worldmap("Port"));
	}

	public static dynamic function waitSec()
	{
		timerText.text = Std.string(StageGlobal.STAGE4_START_TIMER - time);

		FlxTimer.wait(1, () ->
		{
			time++;
			waitSec();
		});
	}

	public static var enemyX:Float = 0;
	public static var enemyCanAttack:Bool = true;

	public static var portJumping:Bool = false;
	public static var portJumpSpeed:Float = 0.5;

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justReleased.SPACE && !portJumping)
		{
			portPreJump();
		}

		if (enemyAttackCondition())
		{
			enemyCanAttack = false;
			enemyCharge();
		}

		super.update(elapsed);
	}

	public static dynamic function enemyAttackCondition():Bool
	{
		return (FlxG.random.bool(25) && enemyCanAttack);
	}

	public static dynamic function portPreJump()
	{
		portJumping = true;

		var portjumpheight:Float = port.height * DISMx2;

		port.animation.play('jump');
		portJump(portjumpheight);
	}

	public static dynamic function portJump(portjumpheight:Float)
	{
		FlxTween.tween(port, {y: port.y - portjumpheight}, portJumpSpeed, {
			onComplete: tween ->
			{
				portFall(portjumpheight);
			}
		});
	}

	public static dynamic function portFall(portjumpheight:Float)
	{
		FlxTween.tween(port, {y: port.y + portjumpheight}, portJumpSpeed, {
			onComplete: tween ->
			{
				portJumping = false;
				port.animation.play('run');
			}
		});
	}

	public static dynamic function enemyCharge()
	{
		FlxTween.tween(enemy, {x: port.x}, 1, {
			onComplete: tween ->
			{
				enemyChargeComplete();
			}
		});
	}

	public static dynamic function enemyChargeComplete()
	{
		if (enemy.overlaps(port))
		{
			FlxG.camera.flash();
			FlxG.switchState(() -> new Worldmap("Port"));
		}

		enemyRetreat();
	}

	public static dynamic function enemyRetreat()
	{
		FlxTween.tween(enemy, {x: enemyX}, 1, {
			onComplete: enemyRetreatComplete()
		});
	}

	public static dynamic function enemyRetreatComplete():TweenCallback
	{
		return tween ->
		{
			FlxTimer.wait(FlxG.random.int(1, 2), () ->
			{
				enemyCanAttack = true;
			});
		}
	}
}
