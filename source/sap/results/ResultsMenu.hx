package sap.results;

import flixel.util.typeLimit.NextState;

class ResultsMenu extends State
{
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

	public var nextState:NextState;

        public var script:HaxeScript;

	override public function new(goods:Int = 0, total:Int = 0, nextState:NextState, ?char:String = 'sinco')
	{
		this.nextState = nextState;

		TARGET_PERCENT = (goods / total) * 100;
		RANK_CLASS = new Rank((TARGET_PERCENT == null) ? 0 : TARGET_PERCENT);

		RANK_GRADE_TEXT = new FlxText(10, 10, FlxG.width, '${Global.getLocalizedPhrase('YOU DID')}...', 64);

		RANK_PERCENT_TEXT = new FlxText(0, 0, 0, '0%', 32);
		RANK_PERCENT_TEXT.setPosition(10, RANK_GRADE_TEXT.y + RANK_GRADE_TEXT.height + 8);
		RANK_PERCENT_TEXT.color = 0x000000;
                RANK_PERCENT_TEXT.alpha = 0.5;
		RANK_PERCENT_TEXT.alignment =LEFT;

		RESULTS_CHARACTER = new ResultsChar(char);
		RESULTS_CHARACTER.screenCenter(XY);

		RESULTS_BG = new BlankBG();
		RESULTS_BG.color = 0x999999;
		RESULTS_BG.screenCenter(XY);

                var scriptPath:String = FileManager.getScriptFile('gameplay/Results');

		TryCatch.tryCatch(() ->
		{
			script = HaxeScript.create(scriptPath);
			script.loadFile(scriptPath);
			ScriptSupport.setScriptDefaultVars(script, '', '');

			script.setVariable('RANK_CLASS', RANK_CLASS);

			script.setVariable('PERCENT', PERCENT);

			script.setVariable('TARGET_PERCENT', TARGET_PERCENT);

			script.setVariable('REACHED_TARGET_PERCENT', REACHED_TARGET_PERCENT);

			script.setVariable('PERCENT_TICK', PERCENT_TICK);

                        script.setVariable('PERCENT_TICK_GOAL', PERCENT_TICK_GOAL);

                        script.setVariable('RANK_GRADE_TEXT', RANK_GRADE_TEXT);
                        script.setVariable('RANK_PERCENT_TEXT', RANK_PERCENT_TEXT);

                        script.setVariable('RESULTS_CHARACTER', RESULTS_CHARACTER);

                        script.setVariable('RESULTS_BG', RESULTS_BG);

                        script.setVariable('nextState', nextState);

			script.executeFunc("create");
		});


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
	}

	override public function update(elapsed:Float):Void
	{
		STATIC_RANK_CLASS = RANK_CLASS;
		STATIC_TARGET_PERCENT = TARGET_PERCENT;
		STATIC_RESULTS_BG = RESULTS_BG;

		if (RESULTS_CHARACTER.animation.name != RANK_CLASS.grade(PERCENT))
			RESULTS_CHARACTER.animation.play(RANK_CLASS.grade(PERCENT));

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

		if (FlxG.keys.justReleased.SPACE && REACHED_TARGET_PERCENT)
		{
                        FlxG.sound.music.stop();
			FlxG.switchState(nextState);
		}

		PERCENT_TICK++;

		super.update(elapsed);
	}

	public static dynamic function playRankMusic()
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
			PERCENT = TARGET_PERCENT;

		RANK_PERCENT_TEXT.text = '${FlxMath.roundDecimal(PERCENT, 0)}%';
	}

	public function rankBuildUpComplete():Void
	{
		if (!REACHED_TARGET_PERCENT)
			trace('Rank Target Made!');
		else
			return;

		FlxG.camera.flash();
		rankBGColor();
		RESULTS_BG.color = STATIC_RESULTS_BG.color;

		RANK_GRADE_TEXT.text = '${Global.getLocalizedPhrase('YOU DID')} ${RANK_CLASS.RANK.toUpperCase()}!';
		RANK_PERCENT_TEXT.setPosition(10, RANK_GRADE_TEXT.y + RANK_GRADE_TEXT.height + 8);
		Global.changeDiscordRPCPresence('Results menu for ${RESULTS_CHARACTER.char}', 'Rank: ${RANK_CLASS.RANK}');

		REACHED_TARGET_PERCENT = true;
	}

	public static dynamic function rankBGColor()
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
