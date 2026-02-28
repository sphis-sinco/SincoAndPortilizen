package;

import macohi.debugging.CrashHandler;
import lime.app.Application;
import openfl.Lib;
import haxe.CallStack;
import openfl.events.UncaughtErrorEvent;

class Main extends openfl.display.Sprite
{
	public function new():Void
	{
		CrashHandler.initalize('', 'SAP_', '', 'SincoAndPortilizen');
		
		// Set the current working directory for Android and iOS devices
		#if android
		// On Android use External Files Dir.
		Sys.setCwd(haxe.io.Path.addTrailingSlash(extension.androidtools.content.Context.getExternalFilesDir()));
		/*#elseif ios
			// On iOS use Documents Dir.
			Sys.setCwd(haxe.io.Path.addTrailingSlash(lime.system.System.documentsDirectory)); */
		#end

		super();
		addChild(new FlxGame(0, 0, InitState));
	}
}
