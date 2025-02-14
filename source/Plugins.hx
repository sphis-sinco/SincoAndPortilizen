import sinlib.SLGame;

class Plugins
{
	public static function init()
	{
		#if !DISABLE_SCREENSHOT
		addPlugin(() -> new ScreenShotPlugin());
		if (SLGame.isDebug) ScreenShotPlugin.screenshotKey = F1;
		#end
	}

	public static function addPlugin(state:Dynamic)
	{
		flixel.FlxG.plugins.addIfUniqueType(state());
	}
}
