package backend;

class State extends FlxState
{
	override function create()
	{
		super.create();

		add(Global.dummyBG([12, 12, 12]));
	}
}
