package sinlib.utilities;

using StringTools;

class Arrays
{
	/**
	 * Returns an array created from a string
	 * @param string String value
	 * @return Array<String>
	 */
	inline public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
			daList[i] = daList[i].trim();

		return daList;
	}
}
