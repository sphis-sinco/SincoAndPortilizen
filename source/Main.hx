package;

import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		Global.change_saveslot(#if debug 'debug' #else 'release' #end);
		addChild(new FlxGame(0, 0, InitState));
	}
}
