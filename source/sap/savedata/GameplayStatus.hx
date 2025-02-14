package sap.savedata;

class GameplayStatus
{
	public static function returnDefaultGameplayStatus()
	{
		return {
			level: 1,
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
		FlxG.save.data.gameplaystatus.level ??= 1;
	}
}
