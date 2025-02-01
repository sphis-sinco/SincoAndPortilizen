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
		var version = APPCURMETA.get('version');

		return '${version}';
	}

	public static var DEBUG_BUILD(get, never):Bool;

	static function get_DEBUG_BUILD():Bool
	{
		return #if debug true #else false #end;
	}
	public static function pass() {}
}