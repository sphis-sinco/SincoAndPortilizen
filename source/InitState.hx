package;

import haxe.macro.Compiler;
import flixel.system.debug.log.LogStyle;
import lime.app.Application;

// This is initalization stuff + compiler condition flags
class InitState extends FlxState
{
	#if NEWGROUNDS
	public static var NG:NGio;
	#end

	override public function create():Void
	{
		super.create();

		#if (sys && debug)
		var sysPath = Sys.programPath().substring(0, Sys.programPath().indexOf('\\export')).replace('\\', '/');
		sysPath += '/build';

		File.saveContent(sysPath, Std.string(Global.BUILD + 1));

		if (!FileSystem.exists('prev-build')
			|| (FileSystem.exists('prev-build') && (File.getContent('prev-build') != File.getContent('assets/build.txt'))))
		{
			File.saveContent('prev-build', Std.string(Global.BUILD));
			File.saveContent('assets/build.txt', Std.string(Global.BUILD + 1));

			@:privateAccess {
				Global.__buildCache = null;
			}
		}
		#end

		trace(Global.GENERATED_BY);

		Application.current.onExit.add(i ->
		{
			FlxG.save.flush();
		}, true);

		#if NEWGROUNDS
		try
		{
			NG = new NGio(Credentials.APP_ID, Credentials.ENCRYPTION_KEY, Credentials.SESSION_ID);
			io.newgrounds.NG.core.verbose = false;
			io.newgrounds.NG.core.log = function(any:Dynamic, ?pos:haxe.PosInfos):Void
			{
				FlxG.log.add('[Newgrounds API / ${pos.fileName}:${pos.lineNumber} ] :: ${any}');
			}

			NGio.ngDataLoaded.add(() ->
			{
				trace('NG Data Loaded n shit');

				var accessGranted = new FlxText(0, 16, FlxG.width, 'NG account access granted!', 16);
				accessGranted.alignment = 'center';
				if (Global.getCurrentState() == 'Splash')
					accessGranted.y = FlxG.height - accessGranted.height;

				FlxG.state.add(accessGranted);
				FlxTween.tween(accessGranted, {alpha: 0}, 1, {
					ease: FlxEase.sineInOut,
					startDelay: 1
				});
			});
		}
		catch (e)
		{
			trace(e);
		}
		#end

		Global.SAVE_BACKWARDS_COMPATABILITY();

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
		switchToState(new Splash(), 'Splash');
	}

	public static function switchToState(state:FlxState, stateName:String):Void
	{
		trace('Moving to $stateName');
		Global.switchState(state);
	}
}
