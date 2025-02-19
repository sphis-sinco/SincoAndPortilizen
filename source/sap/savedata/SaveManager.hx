package sap.savedata;

class SaveManager
{
	/**
	 * This makes sure there are no null values
	 */
	public static dynamic function setupSave()
	{
		// just the base thing
		FlxG.save.data.language ??= getDefaultSave().language;
		FlxG.save.data.results ??= getDefaultSave().results;
		FlxG.save.data.gameplaystatus ??= getDefaultSave().gameplaystatus;

		// run these functions to make sure no null vals
		Results.setupResults();
		GameplayStatus.setupGameplayStatus();
	}

	public static dynamic function getDefaultSave()
	{
		return {
			language: "english",
			results: Results.returnDefaultResults(),
			gameplaystatus: GameplayStatus.returnDefaultGameplayStatus()
		}
	}

	public static dynamic function getLanguage()
	{
		return FlxG.save.data.language;
	}

	public static dynamic function getResults()
	{
		return FlxG.save.data.results;
	}

	public static dynamic function getGameplaystatus()
	{
		return FlxG.save.data.gameplaystatus;
	}
}
