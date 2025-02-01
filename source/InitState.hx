package;

import cutscenes.intro.IntroCutscene;
import title.TitleState;

class InitState extends FlxState
{
	override public function create()
	{
		trace('Sinco and Portilizen v${Global.VERSION}');

		#if !debug
		proceed();
		#else
		trace('DEBUG BUILD: Press [ANY] to start');
		#end

		super.create();
	}

	override public function update(elapsed:Float)
	{
		#if debug
		if (FlxG.keys.justReleased.ANY)
		{
			proceed();
		}
		#end

		super.update(elapsed);
	}
	public function proceed()
	{
		#if CUTSCENE_TESTING
		trace('Testing Intro Cutscenes');
		FlxG.switchState(IntroCutscene.new);
		#end

		FlxG.switchState(TitleState.new);
	}
}
