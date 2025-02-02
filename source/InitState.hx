package;

import cutscenes.ChaosEmerald;
import cutscenes.intro.IntroCutscene;
import flixel.system.debug.log.LogStyle;
import mainmenu.MainMenu;
import stages.stage1.Stage1;
import title.TitleState;
import worldmap.Worldmap;

class InitState extends FlxState
{
	override public function create()
	{
		trace('Sinco and Portilizen v${Global.VERSION}');

		// Make errors and warnings less annoying.
		LogStyle.ERROR.openConsole = false;
		LogStyle.ERROR.errorSound = null;
		LogStyle.WARNING.openConsole = false;
		LogStyle.WARNING.errorSound = null;

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
		trace('Moving to Chaos Emerald Cutscene');
		FlxG.switchState(() -> new ChaosEmerald());
		return;
		#end

		#if SKIP_TITLE
		trace('Skipping Title');
		FlxG.switchState(() -> new MainMenu());
		return;
		#end

		#if STAGE_1
		trace('Moving to Stage 1');
		FlxG.switchState(() -> new Stage1());
		return;
		#end

		#if WORLDMAP
		trace('Moving to Worldmap');
		FlxG.switchState(() -> new Worldmap());
		return;
		#end


		FlxG.switchState(TitleState.new);

	}
}
