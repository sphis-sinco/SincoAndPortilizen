package sap.debug;

class PauseTesting extends PausableState
{
	var allArts:Array<String> = FileManager.readDirectory('assets/images/pausemenu/', ['.png']);
	var artIndexes:Array<Int> = [0, 0];

	override public function new()
	{
		super(true);

		artEnabled = [false, false];
		artStrings = ['', ''];
	}

	override function create()
	{
		super.create();
	}

	function artEvent(index:Int = 0, art:FlxSprite)
	{
		if (FlxG.keys.pressed.SHIFT)
		{
			artEnabled[index] = !artEnabled[index];

			artStrings[index] = allArts[artIndexes[index]];
			trace('Toggled pause art $index to ${artEnabled[index] ? 'on' : 'off'}');

			return;
		}

		if (!FlxG.keys.pressed.CONTROL) artIndexes[index]++;

		if (artIndexes[index] >= allArts.length)
			artIndexes[index] = 0;

		artStrings[index] = allArts[artIndexes[index]];
		trace('Changed pause art $index to ${artStrings[index]}');
	}

	var increase:Int = 10;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.ONE)
		{
			artEvent(0, leftArt);
		}

		if (FlxG.keys.justReleased.TWO)
		{
			artEvent(1, rightArt);
		}
	}
}
