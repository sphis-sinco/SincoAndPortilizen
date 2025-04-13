package sap.savedata;

import sap.settings.SettingsMenu;

class SaveManager
{
	/**
	 * This makes sure there are no null values
	 */
	public static function setupSave():Void
	{
		// just the base thing
		FlxG.save.data.language ??= getDefaultSave().language;
		FlxG.save.data.settings ??= getDefaultSave().settings;
		FlxG.save.data.results ??= getDefaultSave().results;
		FlxG.save.data.gameplaystatus ??= getDefaultSave().gameplaystatus;
		FlxG.save.data.medals ??= getDefaultSave().medals;
		FlxG.save.data.enabled_mods ??= getDefaultSave().enabled_mods;

		// run these functions to make sure no null vals
		SavedSettings.setupSettings();
		Results.setupResults();
		GameplayStatus.setupGameplayStatus();

		SettingsMenu.window_res(getSettings().window_res);
		SettingsMenu.new_windowres = getSettings().window_res;

		MedalData.unlocked_medals = FlxG.save.data.medals;
	}

	public static function getDefaultSave():Dynamic
	{
		return {
			language: "english",
			settings: SavedSettings.returnDefaultSettings(),
			results: Results.returnDefaultResults(),
			gameplaystatus: GameplayStatus.returnDefaultGameplayStatus(),
			medals: [],
			enabled_mods: []
		}
	}

	public static function getLanguage():Dynamic
	{
		return FlxG.save.data.language;
	}

	public static function getResults():Dynamic
	{
		return FlxG.save.data.results;
	}

	public static function getGameplaystatus():Dynamic
	{
		return FlxG.save.data.gameplaystatus;
	}

	public static function getSettings():Dynamic
	{
		return FlxG.save.data.settings;
	}

	public static function getMedals():Dynamic
	{
		return FlxG.save.data.medals;
	}

	public static function getEnabledMods():Dynamic
	{
		return FlxG.save.data.enabled_mods;
	}

	public static function save():Void
	{
		TryCatch.tryCatch(function()
		{
                        FlxG.save.flush();
		}, {
				traceErr: true
		});
	}
}
