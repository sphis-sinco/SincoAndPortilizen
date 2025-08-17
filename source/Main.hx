package;

class Main extends openfl.display.Sprite
{
	public function new():Void
	{
		super();
		addChild(new FlxGame(0, 0, InitState));
	}
}
