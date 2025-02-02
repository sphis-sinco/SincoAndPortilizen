package;

import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		
		// Set the saveslot to a debug saveslot or a release saveslot
		Global.change_saveslot(#if debug 'debug' #else 'release' #end);

		addChild(new FlxGame(0, 0, InitState));
	}
}
