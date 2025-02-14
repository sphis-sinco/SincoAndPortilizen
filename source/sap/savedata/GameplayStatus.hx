package sap.savedata;

class GameplayStatus
{
	public static function returnDefaultGameplayStatus()
	{
		return {
			levels_complete: [],
		};
	}

	/**
	 * This makes sure there are no null value in the savedata gameplaystatus
	 */
	public static function setupGameplayStatus()
	{
		// just the base thing
		FlxG.save.data.gameplaystatus ??= GameplayStatus.returnDefaultGameplayStatus();

		// actual values
		FlxG.save.data.gameplaystatus.levels_complete ??= [];
	}
}
