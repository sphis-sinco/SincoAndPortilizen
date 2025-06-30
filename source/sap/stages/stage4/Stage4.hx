package sap.stages.stage4;

import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import sap.results.ResultsMenu;

class Stage4 extends PausableState
{
	public static var port:PortS4;
	public static var enemy:EnemyS4;

	public static var bg:FlxSprite;

	public static var timerText:FlxText;
	public static var time:Int = 0;

	public static var DIFFICULTY:String = '';
	public static var diffJson:Stage4DifficultyJson;

	public static var start_timer:Int = 60;

	public static var RUNNING:Bool = false;

	override public function new(difficulty:String):Void
	{
		super(false);

		RUNNING = true;

		DIFFICULTY = difficulty;
		diffJson = FileManager.getJSON(FileManager.getDataFile('stages/stage4/${difficulty}.json'));

		start_timer = diffJson.start_timer;

		portJumping = false;
	}

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
		FlxTimer.wait(start_timer, () ->
		{
			levelComplete();
		});

		timerText = new FlxText(10, 10, 0, "60", 64);
		timerText.screenCenter();
		add(timerText);
		StageGlobals.waitSec(start_timer, time, timerText);

		Global.changeDiscordRPCPresence('Stage 4 (${DIFFICULTY.toUpperCase()}): Dimensional String', null);

		enemyCanAttack = true;

		var tutorial:FlxSprite = new FlxSprite();
		tutorial.loadGraphic(FileManager.getImageFile('gameplay/tutorials/pixel/Space-Dodge'));
		tutorial.screenCenter();
		tutorial.y -= tutorial.height * 2;
		add(tutorial);

		FlxTimer.wait(3, () ->
		{
			FlxTween.tween(tutorial, {alpha: 0}, 1);
		});
	}

	public static function levelComplete():Void
	{
		Global.beatLevel(4);
		moveToResultsMenu(true);
	}

	public static var enemyX:Float = 0;
	public static var enemyCanAttack:Bool = true;

	public static var portJumping:Bool = false;
	public static var portJumpSpeed:Float = 0.5;

	override function update(elapsed:Float):Void
	{
		Global.playMusic('InnerHardware');

		if (Global.keyJustReleased(ESCAPE) && Std.parseInt(timerText.text) >= 1)
		{
			togglePaused();
		}

		port.animation.paused = paused;
		enemy.animation.paused = paused;

		if (Global.keyJustReleased(SPACE) && !portJumping && !paused)
		{
			portPreJump();
		}

		if (Global.keyJustReleased(R) && !paused)
		{
			Global.switchState(new Stage4(DIFFICULTY));
			FlxG.camera.flash(FlxColor.WHITE, .25, null, true);
		}
		if (enemyAttackCondition() && !paused)
		{
			enemyCanAttack = false;
			enemyCharge();
		}

		super.update(elapsed);
	}

	public static function enemyAttackCondition():Bool
	{
		final percent:Float = (diffJson.attack_percentage != null) ? diffJson.attack_percentage : 25;

		return (FlxG.random.bool(percent) && enemyCanAttack);
	}

	public static function portPreJump():Void
	{
		portJumping = true;

		var portjumpheight:Float = port.height * StageGlobals.DISMx2;

		port.animation.play('jump');
		portJump(portjumpheight);
	}

	public static function portJump(portjumpheight:Float):Void
	{
		Global.playSoundEffect('gameplay/portilizen-jump-stage4');
		FlxTween.tween(port, {y: port.y - portjumpheight}, portJumpSpeed, {
			onComplete: tween ->
			{
				portFall(portjumpheight);
			}
		});
	}

	public static function portFall(portjumpheight:Float):Void
	{
		FlxTween.tween(port, {y: port.y + portjumpheight}, portJumpSpeed, {
			onComplete: tween ->
			{
				portJumping = false;
				port.animation.play('run');
			}
		});
	}

	public static function enemyCharge():Void
	{
		FlxTween.tween(enemy, {x: port.x}, 1, {
			onComplete: tween ->
			{
				enemyChargeComplete();
			}
		});
	}

	public static function enemyChargeComplete():Void
	{
		if (enemy.overlaps(port))
		{
			FlxG.camera.flash();
			moveToResultsMenu();
		}

		enemyRetreat();
	}

	public static function moveToResultsMenu(win:Bool = false):Void
	{
		final good = Std.parseInt(timerText.text);
		trace(good);
		if (!win)
			Global.switchState(new ResultsMenu(start_timer - good, start_timer, new Worldmap('portilizen'), "port"));
		else
			Global.switchState(new ResultsMenu(start_timer - good, start_timer, new PostStage4Cutscene(), "port"));
	}

	public static function enemyRetreat():Void
	{
		FlxTween.tween(enemy, {x: enemyX}, 1, {
			onComplete: enemyRetreatComplete()
		});
	}

	public static function enemyRetreatComplete():TweenCallback
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
