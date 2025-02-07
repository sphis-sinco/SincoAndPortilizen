package stages.stage4;

import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class Stage4 extends FlxState
{
	var port:PortS4 = new PortS4();
	var enemy:EnemyS4 = new EnemyS4();

	var bg:FlxSprite = new FlxSprite();

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

		port.y = Std.int(FlxG.height - port.height * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER * (Global.DEFAULT_IMAGE_SCALE_MULTIPLIER));
		enemy.y = port.y;
	}

	var enemyX:Float = 0;
	var enemyCanAttack:Bool = true;

	override function update(elapsed:Float)
	{
		if (FlxG.random.bool(25) && enemyCanAttack)
		{
			enemyCanAttack = false;
			FlxTween.tween(enemy, {x: port.x}, 1, {
				onComplete: tween -> {
					FlxTween.tween(enemy, {x: enemyX}, 1, {onComplete: tween -> {
						FlxTimer.wait(FlxG.random.int(1, 2), () -> {
							enemyCanAttack = true;
						});
					}});
				}
			});
		}

		super.update(elapsed);
	}
}
