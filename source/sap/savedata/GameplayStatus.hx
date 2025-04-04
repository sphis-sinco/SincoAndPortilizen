package sap.savedata;

class GameplayStatus
{
	public static function returnDefaultGameplayStatus():Dynamic
	{
		return {
			levels_complete: [],
		};
	}

	/**
	 * This makes sure there are no null values
	 */
	public static function setupGameplayStatus():Void
	{
		// just the base thing
		FlxG.save.data.gameplaystatus ??= returnDefaultGameplayStatus();

		// actual values
		FlxG.save.data.gameplaystatus.levels_complete ??= [];
	}
}
