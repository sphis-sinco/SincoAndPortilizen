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
	?list:Array<Dynamic>,

	?animated:Bool,
	?included:Bool,
}

enum abstract SettingsDataSettingsItemType(String) from String to String
{
	var TOGGLE = 'toggle';
	var INCREMENT = 'increment';
	var METHOD = 'method';
	var LIST = 'list';
}
