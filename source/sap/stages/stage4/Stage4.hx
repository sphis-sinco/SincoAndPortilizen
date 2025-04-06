package sap.stages.stage4;

import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import sap.results.ResultsMenu;
import sap.worldmap.Worldmap;

class Stage4 extends State
{
	public static var port:PortS4;
	public static var enemy:EnemyS4;

	public static var bg:FlxSprite;

	public static var timerText:FlxText;
	public static var time:Int = 0;

	override function create():Void
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

		port.y = Std.int(FlxG.height - port.height * StageGlobals.DISMx2);
		enemy.y = port.y;

		time = 0;
		FlxTimer.wait(StageGlobals.STAGE4_START_TIMER, () ->
		{
			levelComplete();
		});

		timerText = new FlxText(10, 10, 0, "60", 64);
		timerText.screenCenter();
		add(timerText);
		StageGlobals.waitSec(StageGlobals.STAGE4_START_TIMER, time, timerText);

		Global.changeDiscordRPCPresence('Stage 4: Dimensional String', null);

		enemyCanAttack = true;
	}

	override function postCreate():Void
	{
		super.postCreate();

		var tutorial:FlxSprite = new FlxSprite();
		tutorial.loadGraphic(FileManager.getImageFile('gameplay/tutorials/Space-Dodge'));
		tutorial.screenCenter();
		tutorial.y -= tutorial.height * 2;
		add(tutorial);

		FlxTimer.wait(3, () ->
		{
			FlxTween.tween(tutorial, {alpha: 0}, 1);
		});
	}

	public static dynamic function levelComplete():Void
	{
		Global.beatLevel(4);
		moveToResultsMenu();
	}

	public static var enemyX:Float = 0;
	public static var enemyCanAttack:Bool = true;

	public static var portJumping:Bool = false;
	public static var portJumpSpeed:Float = 0.5;

	override function update(elapsed:Float):Void
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

	public static dynamic function portPreJump():Void
	{
		portJumping = true;

		var portjumpheight:Float = port.height * StageGlobals.DISMx2;

		port.animation.play('jump');
		portJump(portjumpheight);
	}

	public static dynamic function portJump(portjumpheight:Float):Void
	{
		Global.playSoundEffect('gameplay/portilizen-jump-stage4');
		FlxTween.tween(port, {y: port.y - portjumpheight}, portJumpSpeed, {
			onComplete: tween ->
			{
				portFall(portjumpheight);
			}
		});
	}

	public static dynamic function portFall(portjumpheight:Float):Void
	{
		FlxTween.tween(port, {y: port.y + portjumpheight}, portJumpSpeed, {
			onComplete: tween ->
			{
				portJumping = false;
				port.animation.play('run');
			}
		});
	}

	public static dynamic function enemyCharge():Void
	{
		FlxTween.tween(enemy, {x: port.x}, 1, {
			onComplete: tween ->
			{
				enemyChargeComplete();
			}
		});
	}

	public static dynamic function enemyChargeComplete():Void
	{
		if (enemy.overlaps(port))
		{
			FlxG.camera.flash();
			moveToResultsMenu();
		}

		enemyRetreat();
	}

	public static dynamic function moveToResultsMenu():Void
	{
		MedalData.unlockMedal('Dimensions reached');
		FlxG.switchState(() -> new ResultsMenu(time, StageGlobals.STAGE4_START_TIMER, () -> new Worldmap("Port"), "port"));
	}

	public static dynamic function enemyRetreat():Void
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
