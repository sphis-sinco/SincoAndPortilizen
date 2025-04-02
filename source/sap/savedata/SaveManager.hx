package sap.savedata;

import sap.settings.SettingsMenu;

class SaveManager
{
	/**
	 * This makes sure there are no null values
	 */
	public static dynamic function setupSave()
	{
		// just the base thing
		FlxG.save.data.language ??= getDefaultSave().language;
		FlxG.save.data.settings ??= getDefaultSave().settings;
		FlxG.save.data.results ??= getDefaultSave().results;
		FlxG.save.data.gameplaystatus ??= getDefaultSave().gameplaystatus;
		FlxG.save.data.medals ??= getDefaultSave().medals;

		// run these functions to make sure no null vals
		Settings.setupSettings();
		Results.setupResults();
		GameplayStatus.setupGameplayStatus();

                SettingsMenu.window_res(getSettings().window_res);
                SettingsMenu.new_windowres = getSettings().window_res;

                MedalData.unlocked_medals = FlxG.save.data.medals;
	}

	public static dynamic function getDefaultSave()
	{
		return {
			language: "english",
                        settings: Settings.returnDefaultSettings(),
			results: Results.returnDefaultResults(),
			gameplaystatus: GameplayStatus.returnDefaultGameplayStatus(),
                        medals: []

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

	public static dynamic function getSettings()
	{
		return FlxG.save.data.settings;
	}
}
