package sap.savedata;

class Settings
{
	public static function returnDefaultSettings()
	{
		return {
                        window_res: "640x608"
		};
	}

	/**
	 * This makes sure there are no null values
	 */
	public static function setupSettings()
	{
		// just the base thing
		FlxG.save.data.settings ??= returnDefaultSettings();

		// actual values
                FlxG.save.data.settings.window_res ??= "640x608";
	}
}
