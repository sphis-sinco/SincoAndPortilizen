package;

import lime.app.Application;
import openfl.Lib;
import haxe.CallStack;
import openfl.events.UncaughtErrorEvent;

class Main extends openfl.display.Sprite
{
	#if NEWGROUNDS
	public static var NG:NGio;
	#end

	public function new():Void
	{
		// Set the current working directory for Android and iOS devices
		#if android
		// On Android use External Files Dir.
		Sys.setCwd(haxe.io.Path.addTrailingSlash(extension.androidtools.content.Context.getExternalFilesDir()));
		/*#elseif ios
			// On iOS use Documents Dir.
			Sys.setCwd(haxe.io.Path.addTrailingSlash(lime.system.System.documentsDirectory)); */
		#end

		#if CRASH_HANDLER
		trace('Crash handler temp-disabled');
		// Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end

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
		NG = new NGio(Credentials.APP_ID, Credentials.ENCRYPTION_KEY, Credentials.SESSION_ID);
		// io.newgrounds.NG.core.verbose = false;
		io.newgrounds.NG.core.log = function(any:Dynamic, ?pos:haxe.PosInfos):Void
		{
			FlxG.log.add('[Newgrounds API / ${pos.fileName}:${pos.lineNumber} ] :: ${any}');
		}
		#end

		super();
		addChild(new FlxGame(0, 0, InitState));
	}

	// Code was entirely made by sqirra-rng for their fnf engine named 'Izzy Engine', big props to them!!!
	// very cool person for real they don't get enough credit for their work
	// several modifs made obv
	#if CRASH_HANDLER
	function onCrash(e:UncaughtErrorEvent):Void
	{
		e.preventDefault();
		e.stopImmediatePropagation();
		var errMsg:String = '';
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + ' (line $line)\n';
				default:
					#if sys
					Sys.println(stackItem);
					#end
			}
		}

		errMsg += '\nUncaught Error: ${e.error}Please report this error to the GitHub page: https://github.com/sphis-sinco/SincoAndPortilizen/issues';

		#if sys
		// create a crashlog if file creation is supported
		var path:String;

		var dateNow:String = Date.now().toString();
		dateNow = dateNow.replace(' ', '_');
		dateNow = dateNow.replace(':', '\'');

		path = './crash/SAP_$dateNow.txt';

		if (!FileSystem.exists('./crash/'))
			FileSystem.createDirectory('./crash/');

		File.saveContent(path, '${errMsg}\n');

		Sys.println(errMsg);
		Sys.println('Crash dump saved in crash folder');
		lime.app.Application.current.window.alert(errMsg, 'Uncaught Error');
		#end

		Global.switchState(new menus.LevelSelect());

		#if DISCORDRPC
		DiscordClient.shutdown();
		#end
	}
	#end
}
