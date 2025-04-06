package;
class Main extends Sprite
{
	public function new():Void
	{
		super();
		addChild(new FlxGame(0, 0, InitState));
	}
}
