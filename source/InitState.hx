package;

import flixel.system.debug.log.LogStyle;
import sap.cutscenes.intro.IntroCutscene;
import sap.mainmenu.MainMenu;
import sap.stages.stage1.Stage1;
import sap.stages.stage4.Stage4;
import sap.title.TitleState;
import sap.worldmap.Worldmap;

// This is initalization stuff + compiler condition flags
class InitState extends FlxState
{
	override public function create()
	{
		// Make errors and warnings less annoying.
		#if DISABLE_ANNOYING_ERRORS
		LogStyle.ERROR.openConsole = false;
		LogStyle.ERROR.errorSound = null;
		#end

		#if DISABLE_ANNOYING_WARNINGS
		LogStyle.WARNING.openConsole = false;
		LogStyle.WARNING.errorSound = null;
		#end

		#if !debug
		proceed();
		#end

		super.create();
	}

	override public function update(elapsed:Float)
	{
		#if debug
		// when on debug builds you have to press something to stop
		if (FlxG.keys.justReleased.ANY)
		{
			proceed();
		}
		#end

		super.update(elapsed);
	}

	public function proceed()
	{
		#if !DISABLE_PLUGINS
		Plugins.init();
		#end

		#if CUTSCENE_TESTING
		#elseif SKIP_TITLE
		trace('Skipping Title');
		FlxG.switchState(() -> new MainMenu());
		return;
		#elseif GAMEPLAY
		trace('Moving to Stage 4');
		FlxG.switchState(() -> new Stage4());
		return;
		#elseif WORLDMAP
		trace('Moving to Worldmap');
		FlxG.switchState(() -> new Worldmap());
		return;
		#end

		FlxG.switchState(TitleState.new);
	}
}
