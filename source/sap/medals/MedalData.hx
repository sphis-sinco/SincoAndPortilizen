package sap.medals;

class MedalData
{
	public static var unlocked_medals:Array<String> = [];

	public static function unlockMedal(medal:String = 'award'):Medal
	{
		var medalClass:Medal = new Medal(medal.replace(' ', '-').toLowerCase(), unlocked_medals.contains(medal));

		trace('New medal: ${medal}');

		if (FlxG.save.data.medals.contains(medal))
		{
			trace('MEDAL IS ALREADY EARNED');
		}
		else
		{
			unlocked_medals.push(medal);
			FlxG.save.data.medals = unlocked_medals;
		}

		return medalClass;
	}
}
