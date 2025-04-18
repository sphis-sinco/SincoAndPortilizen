package sinlib.utilities;

import lime.app.Application as App;

class Application
{
	/**
	 * `Application.current.meta`;
	 */
	public static var META(get, never):Map<String, String>;

	static function get_META():Map<String, String>
	{
		return App.current.meta;
	}

	/**
	 * `Application.current.meta.get('build')`;
	 */
	public static var BUILD(get, never):Dynamic;

	static function get_BUILD():Dynamic
	{
		return META.get("build");
	}

	/**
	 * `Application.current.meta.get('company')`;
	 */
	public static var COMPANY(get, never):String;

	static function get_COMPANY():String
	{
		return META.get("company");
	}

	/**
	 * `Application.current.meta.get('file')`;
	 */
	public static var FILE(get, never):String;

	static function get_FILE():String
	{
		return META.get("file");
	}

	/**
	 * `Application.current.meta.get('name')`;
	 */
	public static var NAME(get, never):String;

	static function get_NAME():String
	{
		return META.get("name");
	}

	/**
	 * `Application.current.meta.get('packageName')`;
	 */
	public static var PACKAGE_NAME(get, never):String;

	static function get_PACKAGE_NAME():String
	{
		return META.get("packageName");
	}

	/**
	 * `Application.current.meta.get('version')`;
	 */
	public static var VERSION(get, never):String;

	static function get_VERSION():String
	{
		return META.get("version");
	}
}
