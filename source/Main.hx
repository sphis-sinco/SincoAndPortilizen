package;

import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		
		if (FlxG.keys.pressed.R)
		{
			trace('Gameplaystatus reset');
			FlxG.save.data.gameplaystatus = null;
		}

		Global.change_saveslot(#if debug 'debug' #else 'release' #end);
		addChild(new FlxGame(0, 0, InitState));
	}
}
