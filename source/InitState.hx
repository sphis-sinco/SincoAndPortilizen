package;

import title.TitleState;

class InitState extends FlxState
{
	override public function create()
	{
		FlxG.switchState(new TitleState());

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
