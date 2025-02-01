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
	public static var GAME_BUILD(get, never):String;

	static function get_GAME_BUILD():String
	{
		return APPCURMETA.get('build');
	}
}