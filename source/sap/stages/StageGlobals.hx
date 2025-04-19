package sap.stages;

class StageGlobals
{
	public static final DISMx2:Float = Global.DEFAULT_IMAGE_SCALE_MULTIPLIER * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER;

	public static final JUMP_KEYWORD:String = 'jump';

	public static function waitSec(timer:Float, time:Float, timerText:FlxText):Void
	{
		timerText.text = Std.string(timer - time);

		FlxTimer.wait(1, () ->
		{
			time++;
			waitSec(timer, time, timerText);
		});
	}

	public static var difficultyCycle:Map<String, Array<String>> = [
		'easy' => ['extreme', 'normal'],
		'normal' => ['easy', 'hard'],
		'hard' => ['normal', 'extreme'],
		'extreme' => ['hard', 'easy']
	];

	public static function cycleDifficulty(current:String, left:Bool):String
	{
		return difficultyCycle.get(current)[left ? 0 : 1];
	}
}
