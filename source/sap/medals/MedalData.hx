package sap.medals;

class MedalData
{
	public static var unlocked_medals:Array<String> = [];

	public static var cur_y_offset:Float = 0;

	public static function unlockMedal(medal:String = 'award'):Medal
	{
                if (cur_y_offset < 0)
                        cur_y_offset = 0;

                final actual_medal:String = medal.replace(' ', '-').replace(',', '').toLowerCase();

		final has_medal = unlocked_medals.contains(actual_medal);

		var medalClass:Medal = new Medal(actual_medal, has_medal, cur_y_offset);
		cur_y_offset += 16 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER;

		if (has_medal)
		{
			trace('"$actual_medal" MEDAL IS ALREADY EARNED');
		}
		else
		{
			trace('New medal: ${actual_medal}');
			unlocked_medals.push(actual_medal);
			#if html5
			WebSave.MEDALS = unlocked_medals;
			#else
			FlxG.save.data.medals = unlocked_medals;
			#end
		}

		return medalClass;
	}
}
