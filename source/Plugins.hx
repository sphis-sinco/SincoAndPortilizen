package;

class Plugins
{

    public static function init() {
        #if !DISABLE_SCREENSHOT
        addPlugin(() -> new ScreenShotPlugin());
        #if debug ScreenShotPlugin.screenshotKey = F1; #end
        #end
    }

    public static function addPlugin(state:Dynamic)
    {
		flixel.FlxG.plugins.addIfUniqueType(state());
    }
    
}