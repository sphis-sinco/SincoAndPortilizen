package;

import title.TitleState;

class InitState extends FlxState
{
	override public function create()
	{
		trace('Sinco and Portilizen v${Global.VERSION}');

		FlxG.switchState(new TitleState());

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
