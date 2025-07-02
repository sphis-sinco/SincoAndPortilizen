package sap.savedata;

import funkin.api.newgrounds.NewgroundsClient;
import sap.settings.SettingsMenu;

class SaveManager
{
	/**
	 * This makes sure there are null values
	 */
	public static function clearSave():Void
	{
		// just the base thing
		FlxG.save.data.language = null;
		FlxG.save.data.settings = null;
		FlxG.save.data.results = null;
		FlxG.save.data.gameplaystatus = null;
		FlxG.save.data.medals = null;
		FlxG.save.data.unlocked_characters = null;
		FlxG.save.data.enabled_mods = null;

		#if FEATURE_NEWGROUNDS
		if (!NewgroundsClient.instance.isLoggedIn())
			FlxG.save.data.ngSessionId = null;
		#else
		FlxG.save.data.ngSessionId = null;
		#end
	}

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
		MedalData.unlocked_medals ??= FlxG.save.data.medals;
		if (FlxG.save.data.unlocked_characters == null)
		{
			Worldmap.CURRENT_PLAYER_CHARACTER = 'sinco';
		}
		FlxG.save.data.unlocked_characters ??= getDefaultSave().unlocked_characters;
		FlxG.save.data.enabled_mods ??= getDefaultSave().enabled_mods;
		FlxG.save.data.ngSessionId ??= getDefaultSave().ngSessionId;

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
			unlocked_characters: [],
			enabled_mods: [],
			ngSessionId: null
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

	public static function getUnlockedCharacters():Dynamic
	{
		return FlxG.save.data.unlocked_characters;
	}

	public static function getEnabledMods():Dynamic
	{
		return FlxG.save.data.enabled_mods;
	}

	public static function getNgSessionId():Dynamic
	{
		return FlxG.save.data.ngSessionId;
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
