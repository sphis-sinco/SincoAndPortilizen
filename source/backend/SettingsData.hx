package backend;

typedef SettingsData =
{
	settings:Array<SettingsDataSettingsItem>
}

typedef SettingsDataSettingsItem =
{
	id:String,
	type:String,
	
	?min:Int,
	?max:Int
}
