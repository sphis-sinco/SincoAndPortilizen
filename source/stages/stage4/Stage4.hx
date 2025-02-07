package stages.stage4;

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
		add(enemy);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
