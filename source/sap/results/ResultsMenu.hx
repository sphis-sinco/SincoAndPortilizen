package sap.results;

import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class ResultsMenu extends FlxState
{
	public var RANK_CLASS:Rank;

	public var PERCENT:Float = 0.0;
        
	public var TARGET_PERCENT:Null<Float> = 100.0;

	public var REACHED_TARGET_PERCENT:Bool = false;

	public var PERCENT_TICK:Int = 0;
	public var PERCENT_TICK_GOAL:Int = 5;

	public var RANK_GRADE_TEXT:FlxText;
	public var RANK_PERCENT_TEXT:FlxText;

	override public function new(goods:Int = 0, total:Int = 0)
	{
		TARGET_PERCENT = (goods / total) * 100;
		RANK_CLASS = new Rank((TARGET_PERCENT == null) ? 0 : TARGET_PERCENT);

		RANK_GRADE_TEXT = new FlxText(10, 10, 0, 'YOU DID...', 64);

		RANK_PERCENT_TEXT = new FlxText(0, 0, 0, '0%', 32);
		RANK_PERCENT_TEXT.screenCenter(XY);

		super();
	}

	override public function create():Void
	{
		add(RANK_GRADE_TEXT);
		add(RANK_PERCENT_TEXT);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (PERCENT < TARGET_PERCENT)
		{
			rankBuildUpTick();
		}
		else if (PERCENT_TICK == PERCENT_TICK_GOAL * 2)
		{
			rankBuildUpComplete();
		}

		PERCENT_TICK++;

		super.update(elapsed);
	}
        
	public function rankBuildUpTick():Void
	{
		if (PERCENT_TICK == PERCENT_TICK_GOAL)
		{
			PERCENT_TICK = 0;
			PERCENT += (PERCENT < 1) ? 1 : (PERCENT / TARGET_PERCENT) * 50;
		}

		if (PERCENT > TARGET_PERCENT) PERCENT = TARGET_PERCENT;

		RANK_PERCENT_TEXT.text = '${FlxMath.roundDecimal(PERCENT, 0)}%';
		RANK_PERCENT_TEXT.screenCenter(XY);
	}
        
	public function rankBuildUpComplete():Void
	{
		if (!REACHED_TARGET_PERCENT) trace('Rank Target Made!'); else return;

		FlxG.camera.flash();

		RANK_GRADE_TEXT.text = 'YOU DID ${RANK_CLASS.RANK.toUpperCase()}!';
                RANK_PERCENT_TEXT.setPosition(10, RANK_GRADE_TEXT.y + RANK_GRADE_TEXT.height + 8);
                RANK_PERCENT_TEXT.color = FlxColor.GRAY;

		REACHED_TARGET_PERCENT = true;
	}
}