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

	public static var EASY_DIFF:String = 'easy';
	public static var NORMAL_DIFF:String = 'normal';
	public static var HARD_DIFF:String = 'hard';
	public static var EXTREME_DIFF:String = 'extreme';

	public static var DIFFICULTYS:Array<String> = [EASY_DIFF, NORMAL_DIFF, HARD_DIFF];
	public static var DIFFICULTYS_ALL:Array<String> = [EASY_DIFF, NORMAL_DIFF, HARD_DIFF, EXTREME_DIFF];
	public static var DIFFICULTYS_EASY:Array<String> = [EASY_DIFF, NORMAL_DIFF];
	public static var DIFFICULTYS_HARD:Array<String> = [HARD_DIFF, EXTREME_DIFF];
}
