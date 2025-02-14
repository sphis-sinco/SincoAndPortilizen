package sap.savedata;

class Results
{
	public static function returnDefaultResults()
	{
		return {
			grade: "F",
		};
	}

	/**
	 * This makes sure there are no null values
	 */
	public static function setupResults()
	{
		// just the base thing
		FlxG.save.data.results ??= returnDefaultResults();

		// actual values
		FlxG.save.data.results.grade ??= "F";
	}
}
