package;

import haxe.macro.Compiler;
import flixel.system.debug.log.LogStyle;

// This is initalization stuff + compiler condition flags
class InitState extends FlxState
{
	override public function create():Void
	{
		super.create();

		if (Compiler.getDefine('SAVESLOT_SUFFIX').split('=').length <= 1)
			Global.change_saveslot((#if debug true #else false #end) ? 'debug' : 'release');
		else
			Global.change_saveslot(Compiler.getDefine('SAVESLOT_SUFFIX').split('=')[0]);

		#if DISCORDRPC
		if (FlxG.save.data.discord_rpc)
			Discord.DiscordClient.initialize();
		else
			Discord.DiscordClient.shutdown();
		#end

		if (FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;
		else
			FlxG.sound.volume = 1;

		FlxG.sound.showSoundTray(false);

		#if html5
		// pixel perfect render fix!
		lime.app.Application.current.window.element.style.setProperty("image-rendering", "pixelated");
		#end

		// Make errors and warnings less annoying.
		#if DISABLE_ANNOYING_ERRORS
		LogStyle.ERROR.openConsole = false;
		LogStyle.ERROR.errorSound = null;
		#end

		#if DISABLE_ANNOYING_WARNINGS
		LogStyle.WARNING.openConsole = false;
		LogStyle.WARNING.errorSound = null;
		#end

		FlxG.sound.volumeUpKeys = [];
		FlxG.sound.volumeDownKeys = [];
		FlxG.sound.muteKeys = [];

		var outdated:Bool = OutdatedCheck.checkForOutdatedVersion();
		#if html5 outdated = false; #end

		if (outdated && !menus.OutdatedMenu.BEGONE)
		{
			trace('OUTDATED');
			switchToState(new menus.OutdatedMenu(), 'Outdated Menu');
			return;
		}

		FlxG.mouse.visible = false;
		switchToState(new Splash(), 'Splash');
	}

	public static function switchToState(state:FlxState, stateName:String):Void
	{
		trace('Moving to $stateName');
		Global.switchState(state);
	}
}
