package sap.results;

import sap.stages.sidebit1.Sidebit1;
import sap.stages.stage5.Stage5;
import sap.stages.stage1.Stage1;
import sap.stages.stage2.Stage2;
import sap.stages.stage4.Stage4;

class ResultsMenu extends FlxState
{
	public static var resultsInstance:ResultsMenu;

	public var RANK_CLASS:Rank;

	public static var STATIC_RANK_CLASS:Rank;

	public var PERCENT:Float = 0.0;

	public var TARGET_PERCENT:Null<Float> = 100.0;

	public static var STATIC_TARGET_PERCENT:Null<Float> = 100.0;

	public var REACHED_TARGET_PERCENT:Bool = false;

	public var PERCENT_TICK:Int = 0;
	public var PERCENT_TICK_GOAL:Int = 5;

	public var RANK_GRADE_TEXT:FlxText;
	public var RANK_PERCENT_TEXT:FlxText;

	public var RESULTS_CHARACTER:ResultsChar;

	public var RESULTS_BG:BlankBG;

	public static var STATIC_RESULTS_BG:BlankBG;

	public var nextState:FlxState;

	override public function new(goods:Int = 0, total:Int = 0, nextState:FlxState, ?char:String = 'sinco'):Void
	{
		this.nextState = nextState;

		if (goods < 0)
		{
			goods = 0;
		}

		TARGET_PERCENT = (goods / total) * 100;
		if (TARGET_PERCENT < 0)
		{
			TARGET_PERCENT = -TARGET_PERCENT;
		}
		RANK_CLASS = new Rank((TARGET_PERCENT == null) ? 0 : TARGET_PERCENT);

		trace('${goods}/${total}');
		trace('${TARGET_PERCENT}%');

		RANK_GRADE_TEXT = new FlxText(10, 10, FlxG.width, '${Global.getLocalizedPhrase('YOU DID')}...', 64);

		RANK_PERCENT_TEXT = new FlxText(0, 0, 0, '0%', 32);
		RANK_PERCENT_TEXT.setPosition(10, RANK_GRADE_TEXT.y + RANK_GRADE_TEXT.height + 8);
		RANK_PERCENT_TEXT.color = 0x000000;
		RANK_PERCENT_TEXT.alpha = 0.5;
		RANK_PERCENT_TEXT.alignment = LEFT;

		var resultCharacter:String = char;

		if (Worldmap.CURRENT_PLAYER_CHARACTER == char)
		{
			final PCJ:PlayableCharacter = Worldmap.CURRENT_PLAYER_CHARACTER_JSON;

			if (PCJ.results_asset_prefix != null)
				resultCharacter = PCJ.results_asset_prefix;
		}

		RESULTS_CHARACTER = new ResultsChar(resultCharacter);
		RESULTS_CHARACTER.screenCenter(XY);

		RESULTS_BG = new BlankBG();
		RESULTS_BG.color = 0x999999;
		RESULTS_BG.screenCenter(XY);

		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.destroy();
		}

		if (FlxG.sound != null)
		{
			FlxG.sound.destroy();
		}

		super();
	}

	override public function create():Void
	{
		add(RESULTS_BG);

		add(RANK_GRADE_TEXT);
		add(RANK_PERCENT_TEXT);

		add(RESULTS_CHARACTER);

		super.create();

		Global.changeDiscordRPCPresence('Results menu for ${RESULTS_CHARACTER.char}', null);
		resultsInstance = this;

		TryCatch.tryCatch(function()
		{
			if (Stage1.OSIN_HEALTH == 0 && Stage1.RUNNING)
			{
				add(MedalData.unlockMedal('Faker clash'));

				if (Stage1.SINCO_HEALTH == Stage1.SINCO_MAX_HEALTH)
				{
					add(MedalData.unlockMedal('The original stands on top'));
				}

				Stage1.RUNNING = false;
			}
			else if (Stage2.time == 0 && Stage2.RUNNING)
			{
				add(MedalData.unlockMedal('Protector'));
				if (Stage2.TEMPO_CITY_HEALTH == Stage2.diffJson.tempo_city_max_health)
				{
					add(MedalData.unlockMedal('True Protector'));
				}

				Stage2.RUNNING = false;
			}
			else if (Stage4.time == Stage4.start_timer && Stage4.RUNNING)
			{
				add(MedalData.unlockMedal('Dimensions reached'));

				Stage4.RUNNING = false;
			}
			else if (Stage5.RUNNING)
			{
				Stage5.RUNNING = false;
				final flashLength:Int = 2;

				add(MedalData.unlockMedal('The OC of history'));
				if (Stage5.PLAYER_CHARGE > Stage5.OPPONENT_CHARGE)
				{
					FlxG.camera.flash(FlxColor.PURPLE, flashLength);
					add(MedalData.unlockMedal('Brothers split again'));
				}
				else
					FlxG.camera.flash(FlxColor.GREEN, flashLength);
			}
			else if (Sidebit1.RUNNING)
			{
				Sidebit1.RUNNING = false;

				add(MedalData.unlockMedal('The consistentless'));

				if (Sidebit1.SINCO_HEALTH == 0)
				{
					add(MedalData.unlockMedal('The OC of today'));
				}
			}

			SaveManager.save();
		});
	}

	override public function update(elapsed:Float):Void
	{
		STATIC_RANK_CLASS = RANK_CLASS;
		STATIC_TARGET_PERCENT = TARGET_PERCENT;
		STATIC_RESULTS_BG = RESULTS_BG;

		if (RESULTS_CHARACTER.animation.name != RANK_CLASS.grade(PERCENT))
		{
			RESULTS_CHARACTER.animation.play(RANK_CLASS.grade(PERCENT));
		}

		if (PERCENT < TARGET_PERCENT)
		{
			rankBuildUpTick();
		}
		else if (PERCENT_TICK == PERCENT_TICK_GOAL * 2)
		{
			rankBuildUpComplete();
		}

		if (REACHED_TARGET_PERCENT)
		{
			playRankMusic();
		}

		if (Global.keyJustReleased(SPACE) && REACHED_TARGET_PERCENT)
		{
			FlxG.sound.music.stop();
			Global.switchState(nextState);
		}

		PERCENT_TICK++;

		super.update(elapsed);
	}

	public static function playRankMusic():Void
	{
		var songSuffix:String = STATIC_RANK_CLASS.gradeUntranslated(STATIC_TARGET_PERCENT);

		switch (STATIC_RANK_CLASS.gradeUntranslated(STATIC_TARGET_PERCENT))
		{
			case 'good' | 'great':
				songSuffix = 'good';
			case 'awful' | 'bad':
				songSuffix = 'awful';
		}

		TryCatch.tryCatch(() ->
		{
			Global.playMusic('rank-$songSuffix');
		});
	}

	public function rankBuildUpTick():Void
	{
		if (PERCENT_TICK == PERCENT_TICK_GOAL)
		{
			PERCENT_TICK = 0;
			PERCENT += (PERCENT < 1) ? 1 : (PERCENT / TARGET_PERCENT) * 50;
		}

		if (PERCENT > TARGET_PERCENT)
		{
			PERCENT = TARGET_PERCENT;
		}

		RANK_PERCENT_TEXT.text = '${FlxMath.roundDecimal(PERCENT, 0)}%';
	}

	public function rankBuildUpComplete():Void
	{
		if (!REACHED_TARGET_PERCENT)
		{
			trace('Rank Target (${TARGET_PERCENT}%) Made!');
		}
		else
		{
			return;
		}

		FlxG.camera.flash();
		rankBGColor();
		RESULTS_BG.color = STATIC_RESULTS_BG.color;

		RANK_GRADE_TEXT.text = '${Global.getLocalizedPhrase('YOU DID')} ${RANK_CLASS.RANK.toUpperCase()}!';
		RANK_PERCENT_TEXT.setPosition(10, RANK_GRADE_TEXT.y + RANK_GRADE_TEXT.height + 8);
		Global.changeDiscordRPCPresence('Results menu for ${RESULTS_CHARACTER.char}', 'Rank: ${RANK_CLASS.RANK}');

		REACHED_TARGET_PERCENT = true;
	}

	public static function rankBGColor():Void
	{
		switch (STATIC_RANK_CLASS.gradeUntranslated(STATIC_TARGET_PERCENT))
		{
			default:
				STATIC_RESULTS_BG.color = 0xffd93f;
			case 'good' | 'great':
				STATIC_RESULTS_BG.color = 0xad4e1a;
			case 'awful' | 'bad':
				STATIC_RESULTS_BG.color = 0xb23f24;
		}
	}
}
