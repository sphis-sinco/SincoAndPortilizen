import funkin.util.plugins.ScreenshotPlugin;

class Plugins
{
	public static dynamic function init()
	{
		#if !DISABLE_SCREENSHOT
                ScreenshotPlugin.initialize();
		#end
	}

	public static function addPlugin(state:Dynamic)
	{
		flixel.FlxG.plugins.addIfUniqueType(state());
	}
}
