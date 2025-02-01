package;

import lime.app.Application;

class Global
{
	public static var APPCURMETA(get, never):Map<String, String>;

	static function get_APPCURMETA():Map<String, String>
	{
		return Application.current.meta;
	}

	public static var VERSION(get, never):String;

	static function get_VERSION():String
	{
		return APPCURMETA.get('version');
	}
}