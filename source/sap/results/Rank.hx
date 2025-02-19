package sap.results;

class Rank
{
	public var RANK:String = '';

	public function new(percent:Float = 0.0)
	{
		RANK = grade(percent);
	}

	public function grade(percent:Float = 0.0):String
	{
		return Global.getLocalizedPhrase('rank-${gradeUntranslated(percent)}');
	}

	public function gradeUntranslated(percent:Float = 0.0):String
	{
		if (percent == 100) return 'perfect';
		if (percent >= 90) return 'excellent';
		if (percent >= 80) return 'great';
		if (percent >= 60) return 'good';
		if (percent >= 10) return 'bad';

		return 'awful';
	}
}
