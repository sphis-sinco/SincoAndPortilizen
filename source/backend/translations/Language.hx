package backend.translations;

typedef Language =
{
	?assetSuffix:String,
	?pause:String,
	?levelSelect:Dynamic,
	?settings:LanguageSettings
}

typedef LanguageSettings =
{
	coloredLevelSelect:LanguageSettingsSetting,
	discordRPC:LanguageSettingsSetting,
	volume:LanguageSettingsSetting,
	clearSave:LanguageSettingsSetting,

	value_enabled:String,
	value_disabled:String
}

typedef LanguageSettingsSetting =
{
	name:String,
	description:String,
	displayKey:String
}
