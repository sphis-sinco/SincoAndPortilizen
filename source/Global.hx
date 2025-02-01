package;

import lime.app.Application;

class Global
{
	public static var VERSION(get, never):String;

	static function get_VERSION():String
	{
		return Application.current.meta.get('version');
	}
}