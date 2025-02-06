package stages.stage4;

import flixel.util.FlxTimer;

class Stage4 extends FlxState
{
	var port:PortS4 = new PortS4();
	var port_dir:Int = 0; // 0 - left, 1 - down, 2 - up, 3 - right
	var enemy:EnemyS4 = new EnemyS4();

	override function create()
	{
		super.create();

		port.screenCenter();
		add(port);

		enemy.screenCenter();
		add(enemy);

		moveOp();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.LEFT)
			port_dir = 0;
		if (FlxG.keys.justReleased.DOWN)
			port_dir = 1;
		if (FlxG.keys.justReleased.UP)
			port_dir = 2;
		if (FlxG.keys.justReleased.RIGHT)
			port_dir = 3;
	}

	public function moveOp()
	{
		switch (port_dir)
		{
			case 0:
				port.flipX = true;
				port.x -= port.width;
			case 1:
				port.y += port.width;
			case 2:
				port.y -= port.width;
			case 3:
				port.flipX = false;
				port.x += port.width;
		}

		FlxTimer.wait(1, () ->
		{
			moveOp();
		});
	}
}
