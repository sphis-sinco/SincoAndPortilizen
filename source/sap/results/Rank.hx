package sap.results;

class Rank
{
	public static var RANK_PERFECT_PERCENT:Float = 1;
	public static var RANK_EXCELLENT_PERCENT:Float = 0.9;
	public static var RANK_GREAT_PERCENT:Float = 0.8;
	public static var RANK_GOOD_PERCENT:Float = 0.6;
	public static var RANK_BAD_PERCENT:Float = 0.1;

	public var RANK:String = '';

	public function new(percent:Float = 0.0):Void
	{
		RANK = grade(percent);
	}

	public function grade(percent:Float = 0.0):String
	{
		return Global.getLocalizedPhrase('rank-${gradeUntranslated(percent)}');
	}

	public function gradeUntranslated(percent:Float = 0.0):String
	{
		if (percent == RANK_PERFECT_PERCENT * 100)
		{
			return 'perfect';
		}
		if (percent >= RANK_EXCELLENT_PERCENT * 100)
		{
			return 'excellent';
		}
		if (percent >= RANK_GREAT_PERCENT * 100)
		{
			return 'great';
		}
		if (percent >= RANK_GOOD_PERCENT * 100)
		{
			return 'good';
		}
		if (percent >= RANK_BAD_PERCENT * 100)
		{
			return 'bad';
		}

		return 'awful';
	}
}
