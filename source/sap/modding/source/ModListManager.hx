package sap.modding.source;

class ModListManager
{
	/**
	 * List of mod files
	 */
	public static var modList:Array<ModBasic> = [];

	/**
	 * Adds a mod to `modList`
	 * @param newmod the mod your adding
	 */
	public static function addMod(newmod:ModBasic):Void
	{
		modList.push(newmod);
	}

	public static function create():Void
	{
		for (mod in modList)
		{
			if (mod.enabled)
				mod.create();
		}
	}

	/**
	 * Runs every frame updating every mod.
	 * @param elapsed elapsed
	 */
	public static function update(elapsed:Float):Void
	{
		for (mod in modList)
		{
			if (mod.enabled)
				mod.update(elapsed);
		}
	}
}
