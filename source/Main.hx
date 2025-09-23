package;

import lime.app.Application;
import openfl.Lib;
import haxe.CallStack;
import openfl.events.UncaughtErrorEvent;

class Main extends openfl.display.Sprite
{
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
