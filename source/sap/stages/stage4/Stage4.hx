package sap.stages.stage4;

import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import sap.worldmap.Worldmap;

class Stage4 extends FlxState
{
	var port:PortS4 = new PortS4();
	var enemy:EnemyS4 = new EnemyS4();

	var bg:FlxSprite = new FlxSprite();

	public static var DISMx2:Float = Global.DEFAULT_IMAGE_SCALE_MULTIPLIER * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER;

	override function create()
	{
		super.create();

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

		FlxTimer.wait(60, () ->
		{
			Global.setLevel(5);
			FlxG.switchState(() -> new Worldmap("Port"));
		});
	}

	var enemyX:Float = 0;
	var enemyCanAttack:Bool = true;

	var portJumping:Bool = false;
	var portJumpSpeed:Float = 0.5;

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justReleased.SPACE && !portJumping)
		{
			portJumping = true;

			var portjumpheight:Float = port.height * DISMx2;

			port.animation.play('jump');
			portJump(portjumpheight);
		}

		if (FlxG.random.bool(25) && enemyCanAttack)
		{
			enemyCanAttack = false;
			enemyCharge();
		}

		super.update(elapsed);
	}

	public function portJump(portjumpheight:Float)
	{
		FlxTween.tween(port, {y: port.y - portjumpheight}, portJumpSpeed, {
			onComplete: tween ->
			{
				portFall(portjumpheight);
			}
		});
	}

	public function portFall(portjumpheight:Float)
	{
		FlxTween.tween(port, {y: port.y + portjumpheight}, portJumpSpeed, {
			onComplete: tween ->
			{
				portJumping = false;
				port.animation.play('run');
			}
		});
	}

	public function enemyCharge()
	{
		FlxTween.tween(enemy, {x: port.x}, 1, {
			onComplete: tween ->
			{
				enemyChargeComplete();
			}
		});
	}

	public function enemyChargeComplete()
	{
		if (enemy.overlaps(port))
		{
			FlxG.camera.flash();
			FlxG.switchState(() -> new Worldmap("Port"));
		}

		enemyRetreat();
	}

	public function enemyRetreat()
	{
		FlxTween.tween(enemy, {x: enemyX}, 1, {
			onComplete: enemyRetreatComplete()
		});
	}

	public function enemyRetreatComplete():TweenCallback
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
