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
		if (percent == 100) return PhraseManager.getPhrase('rank-perfect', 'perfect');
		if (percent >= 90) return PhraseManager.getPhrase('rank-excellent', 'excellent');
		if (percent >= 80) return PhraseManager.getPhrase('rank-great', 'great');
		if (percent >= 60) return PhraseManager.getPhrase('rank-good', 'good');
		if (percent >= 10) return PhraseManager.getPhrase('rank-bad', 'bad');

		return PhraseManager.getPhrase('rank-awful', 'awful');
	}
}
