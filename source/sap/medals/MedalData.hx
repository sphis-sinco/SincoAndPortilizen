package sap.medals;

class MedalData
{
	public static var unlocked_medals:Array<String> = [];

	public static var cur_y_offset:Float = 0;

	public static function unlockMedal(medal:String = 'award'):Medal
	{
		var medalClass:Medal = new Medal(medal.replace(' ', '-').replace(',', '').toLowerCase(), unlocked_medals.contains(medal), cur_y_offset);
		cur_y_offset += 16 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER;

		trace('New medal: ${medal}');

		#if sys
		if (FlxG.save.data.medals.contains(medal))
		#else
		if (WebSave.MEDALS.contains(medal))
		#end
		{
			trace('MEDAL IS ALREADY EARNED');
		}
	else
	{
		unlocked_medals.push(medal);
		#if sys
		FlxG.save.data.medals = unlocked_medals;
		#else
		WebSave.MEDALS = unlocked_medals;
		#end
	}

		return medalClass;
	}
}
