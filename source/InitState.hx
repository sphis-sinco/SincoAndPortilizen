package;

import flixel.system.debug.log.LogStyle;

// This is initalization stuff + compiler condition flags
class InitState extends FlxState
{
	override public function create():Void
	{
		super.create();
	
		Global.change_saveslot((#if debug true #else false #end) ? 'debug' : 'release');

		#if DISCORDRPC
		if (FlxG.save.data.discord_rpc)
			Discord.DiscordClient.initialize();
		else
			Discord.DiscordClient.shutdown();
		#end

		FlxG.sound.volume = FlxG.save.data.volume;

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

		switchToState(new menus.LevelSelect(), 'Level Select');
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	public static function switchToState(state:FlxState, stateName:String):Void
	{
		trace('Moving to $stateName');
		Global.switchState(state);
	}
}
