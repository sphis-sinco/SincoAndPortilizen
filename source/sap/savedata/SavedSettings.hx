package sap.savedata;

class SavedSettings
{
	public static function returnDefaultSettings():Dynamic
	{
		return {
			window_res: "640x608",
			discord_rpc: true,
			volume: 100
		};
	}

	/**
	 * This makes sure there are no null values
	 */
	public static function setupSettings():Void
	{
		// just the base thing
		FlxG.save.data.settings ??= returnDefaultSettings();

		// actual values
		FlxG.save.data.settings.window_res ??= "640x608";
		FlxG.save.data.settings.discord_rpc ??= true;
		FlxG.save.data.settings.volume ??= 100;
	}
}
