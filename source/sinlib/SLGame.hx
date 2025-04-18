package sinlib;

/**
 * Short name/nickname: SLG
 */
class SLGame
{
	/**
	 * Tells if your game is in a debug build
	 */
	public static var isDebug(get, never):Bool;

	static function get_isDebug():Bool
	{
		return #if debug true #else false #end;
	}

	/**
	 * Tells if your game is in a watch build
	 */
	public static var isWatch(get, never):Bool;

	static function get_isWatch():Bool
	{
		return #if watch true #else false #end;
	}
}
