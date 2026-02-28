package backend;

typedef SettingsData =
{
	settings:Array<SettingsDataSettingsItem>
}

typedef SettingsDataSettingsItem =
{
	asset:String,
	id:String,
	savefield:String,
	type:SettingsDataSettingsItemType,

	?max:Int,

	?animated:Bool,
}

enum abstract SettingsDataSettingsItemType(String) from String to String
{
	var TOGGLE = 'toggle';
	var INCREMENT = 'increment';
}
