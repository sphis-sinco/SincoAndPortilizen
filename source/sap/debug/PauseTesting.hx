package sap.debug;

class PauseTesting extends PausableState
{
	var allArts:Array<String> = FileManager.readDirectory('assets/images/pausemenu/', ['.png']);
	var artIndexes:Array<Int> = [0, 0, 0];

	override public function new()
	{
		super(true);

		artEnabled = [true, false, false];
		artStrings = ['', '', ''];
	}

	public function getOffsets()
	{
		var suffix = '-left';
		var paoPath = 'assets/images/pausemenu/${artStrings[artIndexes[0]]}${suffix}.pao';
		var left = FileManager.readFile(paoPath).split('\n');
		var suffix = '-center';
		var paoPath = 'assets/images/pausemenu/${artStrings[artIndexes[1]]}${suffix}.pao';
		var center = FileManager.readFile(paoPath).split('\n');
		var suffix = '-right';
		var paoPath = 'assets/images/pausemenu/${artStrings[artIndexes[2]]}${suffix}.pao';
		var right = FileManager.readFile(paoPath).split('\n');

		offsets[0][0] = Std.parseFloat(left[0]);
		offsets[0][1] = Std.parseFloat(left[1]);
		offsets[1][0] = Std.parseFloat(center[0]);
		offsets[1][1] = Std.parseFloat(center[1]);
		offsets[2][0] = Std.parseFloat(right[0]);
		offsets[2][1] = Std.parseFloat(right[1]);
	}

	override function create()
	{
		super.create();
	}

	public var offsets:Array<Array<Float>> = [[0, 0], [0, 0], [0, 0]];

	function artEvent(index:Int = 0, art:FlxSprite)
	{
		if (FlxG.keys.pressed.CONTROL)
		{
			var different = (FlxG.keys.anyPressed([LEFT, DOWN, UP, RIGHT]));

			var suffix:String = '';
			switch (index)
			{
				case 0:
					suffix = '-left';
				case 1:
					suffix = '-center';
				case 2:
					suffix = '-right';
			}

			if (art == null)
			{
				return;
			}

			if (FlxG.keys.pressed.LEFT)
			{
				offsets[index][0] -= increase;
				art.x -= increase;
			}
			if (FlxG.keys.pressed.RIGHT)
			{
				offsets[index][0] += increase;
				art.x += increase;
			}
			if (FlxG.keys.pressed.UP)
			{
				offsets[index][1] -= increase;
				art.y -= increase;
			}
			if (FlxG.keys.pressed.DOWN)
			{
				offsets[index][1] += increase;
				art.y += increase;
			}

			FileManager.writeToPath('assets/images/pausemenu/${artStrings[index].replace('.png', '')}${suffix}.pao',
				'${offsets[index][0]}\n${offsets[index][1]}');

			if (different)
				trace('$index offsets: ${offsets[index]}');
			return;
		}

		if (FlxG.keys.pressed.SHIFT)
		{
			artEnabled[index] = !artEnabled[index];

			artStrings[index] = allArts[artIndexes[index]];
			trace('Toggled pause art $index to ${artEnabled[index] ? 'on' : 'off'}');

			getOffsets();

			art = artInit(index);
			art.x += offsets[index][0];
			art.y += offsets[index][1];

			return;
		}

		artIndexes[index]++;

		if (artIndexes[index] >= allArts.length)
			artIndexes[index] = 0;

		artStrings[index] = allArts[artIndexes[index]];
		trace('Changed pause art $index to ${artStrings[index]}');
	}

	var increase:Int = 10;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.ONE || FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.ONE)
		{
			artEvent(0, leftArt);
		}

		if (FlxG.keys.justReleased.TWO || FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.TWO)
		{
			artEvent(1, centerArt);
		}

		if (FlxG.keys.justReleased.THREE || FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.THREE)
		{
			artEvent(2, rightArt);
		}
	}
}
