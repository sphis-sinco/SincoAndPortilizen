package sap.stages;

class StageGlobals
{
	public static var STAGE2_PLAYER_START_Y:Int = 384;
	public static var STAGE2_PLAYER_JUMP_Y_OFFSET:Float = 240;
	public static var STAGE2_PLAYER_JUMP_SPEED:Float = 0.5;
	public static var STAGE2_MAX_ROCKS:Int = 2;
	public static var STAGE2_START_TIMER:Int = 60;
	public static var STAGE2_TEMPO_CITY_MAX_HEALTH:Int = 5;
	public static var STAGE2_BG_POSITION_DECREASE:Float = 50;

	public static var STAGE4_START_TIMER:Int = 60;

	public static final DISMx2:Float = Global.DEFAULT_IMAGE_SCALE_MULTIPLIER * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER;

	public static final JUMP_KEYWORD:String = 'jump';

	public static dynamic function waitSec(timer:Float, time:Float, timerText:FlxText):Void
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
