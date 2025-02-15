package sap.savedata;

class SaveManager
{
	/**
	 * This makes sure there are no null values
	 */
	public static function setupSave()
	{
		// just the base thing
		FlxG.save.data.language ??= getDefaultSave().language;
		FlxG.save.data.results ??= getDefaultSave().results;
		FlxG.save.data.gameplaystatus ??= getDefaultSave().gameplaystatus;


                // run these functions to make sure no null vals
		Results.setupResults();
		GameplayStatus.setupGameplayStatus();
	}

	public static function getDefaultSave()
	{
		return {
                        language: "english",
			results: Results.returnDefaultResults(),
			gameplaystatus: GameplayStatus.returnDefaultGameplayStatus()
		}
	}

	public static function getLanguage()
	{
		return FlxG.save.data.language;
	}

	public static function getResults()
	{
		return FlxG.save.data.results;
	}

	public static function getGameplaystatus()
	{
		return FlxG.save.data.gameplaystatus;
	}
}
