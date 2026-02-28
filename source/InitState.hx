package;

import backend.translations.Translate;
import menus.LevelSelect;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import haxe.macro.Compiler;
import flixel.system.debug.log.LogStyle;
import lime.app.Application;

// This is initalization stuff + compiler condition flags
class InitState extends FlxState
{
	override public function create():Void
	{
		super.create();

		trace(Global.GENERATED_BY);

		#if !html5
		try
		{
			if (Compiler.getDefine('SAVESLOT_SUFFIX').split('=').length <= 1)
				Global.change_saveslot((#if debug true #else false #end) ? 'debug' : 'release');
			else
				Global.change_saveslot(Compiler.getDefine('SAVESLOT_SUFFIX').split('=')[0]);
		}
		catch (e)
		{
			Global.change_saveslot((#if debug true #else false #end) ? 'debug' : 'release');
		}
		#else
		Global.change_saveslot((#if debug true #else false #end) ? 'debug' : 'release');
		#end

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

		#if !MOBILE_TESTING
		FlxG.mouse.visible = false;
		#end

		Application.current.onExit.add(i ->
		{
			FlxG.save.flush();
		}, true);

		LevelSelect.levelFolderData = Assets.getFileJsonContent('level_folders/base.json');

		Translate.init();
		if (FlxG.save.data.language != null)
			Translate.getLanguage(FlxG.save.data.language);
		else
			Translate.getLanguage(Translate.DEFAULT_LANGUAGE);

		switchToState(new Splash(), 'Splash');
	}

	public static function switchToState(state:FlxState, stateName:String):Void
	{
		trace('Moving to $stateName');
		Global.switchState(state);
	}
}
