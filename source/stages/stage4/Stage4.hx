package stages.stage4;

import flixel.util.FlxTimer;

class Stage4 extends FlxState
{
	var port:PortS4 = new PortS4();
	var enemy:EnemyS4 = new EnemyS4();

	override function create()
	{
		super.create();

		port.screenCenter();
		add(port);

		enemy.screenCenter();
		add(enemy);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
