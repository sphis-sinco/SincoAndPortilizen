package;

import funkin.util.logging.CrashHandler;

class Main extends Sprite
{
	public function new():Void
	{
		// We need to make the crash handler LITERALLY FIRST so nothing EVER gets past it.
		CrashHandler.initialize();
		CrashHandler.queryStatus();

		// Initialize custom logging.
		haxe.Log.trace = funkin.util.logging.AnsiTrace.trace;

		super();
		addChild(new FlxGame(0, 0, InitState));
	}
}
