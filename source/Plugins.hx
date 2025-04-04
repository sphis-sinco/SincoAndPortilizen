package;

import funkin.util.plugins.ScreenshotPlugin;

class Plugins
{
	public static dynamic function init():Void
	{
		#if !DISABLE_SCREENSHOT
		ScreenshotPlugin.initialize();
		#end
	}

	public static function addPlugin(state:Dynamic):Void
	{
		flixel.FlxG.plugins.addIfUniqueType(state());
	}
}
