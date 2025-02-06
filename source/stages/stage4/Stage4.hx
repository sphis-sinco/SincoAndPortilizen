package stages.stage4;

import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxTimer;

class Stage4 extends FlxState
{
	var port:PortS4 = new PortS4();
	var port_dir:Int = 0; // 0 - left, 1 - down, 2 - up, 3 - right

	var level_tilemap:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();

	override function create()
	{
		super.create();

        var leveldata:Array<Dynamic> = FileManager.getJSON(FileManager.getDataFile('Stage4Map.json')).layers[0].data2D;
        trace(leveldata[0]);

        add(level_tilemap);

		port.screenCenter();
		add(port);

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
