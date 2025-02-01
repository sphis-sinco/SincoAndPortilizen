package;

import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		Global.change_saveslot(0); // slot 0 is just misc stuff, or atleast it should be
		addChild(new FlxGame(0, 0, InitState));
	}
}
