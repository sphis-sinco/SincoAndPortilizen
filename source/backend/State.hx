package backend;

class State extends FlxState
{
	override function create()
	{
		super.create();

		add(Global.dummyBG([12, 12, 12]));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		#if !MOBILE_TESTING
		FlxG.mouse.visible = false;
		#end
	}
}
