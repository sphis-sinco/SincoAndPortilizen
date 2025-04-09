package sap.modding.source.mods;

import flixel.util.FlxColor;
import sap.credits.CreditsEntry;
import sap.credits.CreditsSubState;
import sap.mainmenu.MainMenu;
import sap.results.ResultsMenu;
import sap.stages.StageGlobals;
import sap.stages.stage1.Stage1;
import sap.stages.stage4.Stage4;
import sap.title.TitleState;
import sap.worldmap.Worldmap;
import sinlib.SLGame;

class MassMod extends ModBasic
{
	public static var instance:ModBasic;

	var canModCredits:Bool = false;

	override public function new():Void
	{
		super(false);

		instance = this;
	}

	override function create():Void
	{
		trace('Mass mod');

		TitleState.get_versiontext = function():String
		{
			return 'v.mass mod6969.1';
		}

		Global.change_saveslot((SLGame.isDebug) ? 'debug_massmod' : 'release_massmod');

		Stage4.start_timer = 240;
		super.create();
	}

	override function onStateSwitchComplete():Void
	{
		super.onStateSwitchComplete();

		if (Global.getCurrentState() == "TitleState")
		{
			trace('Title!');
		}

		if (Global.getCurrentState() == "MainMenu" || Global.getCurrentState() == "PlayMenu")
		{
			trace('Menu!');
			MainMenu.sinco.visible = false;
			MainMenu.port.visible = false;
		}

		if (Global.getCurrentState() == "Worldmap")
		{
			trace('Worldmap!');
			Worldmap.character.swappedchar();
		}

		if (Global.getCurrentState() == "Stage1")
		{
			trace('Stage 1!');

			Stage1.getOsinJumpCondition = newOsinJumpCondition;

			Stage1.osin.color = FlxColor.YELLOW;

			Stage1.OSIN_MAX_HEALTH = 100;
			Stage1.SINCO_MAX_HEALTH = 5;
		}

		if (Global.getCurrentState() == "Stage4")
		{
			Stage4.start_timer = 240;
			trace('Stage 4!');
			Stage4.enemyAttackCondition = function():Bool
			{
				return true;
			}
		}

		if (Global.getCurrentState() == "ResultsMenu")
		{
			trace('Wats da rank?');

			ResultsMenu.rankBGColor = newRankBGColors;
		}
	}

	function newOsinJumpCondition():Bool
	{
		return (Stage1.SINCO_HEALTH >= 1
			&& Stage1.OSIN_HEALTH >= 1
			&& FlxG.random.int(0, 1) == 1
			&& (Stage1.osin.animation.name != 'jump' && Stage1.osin.animation.name != 'hurt')
			&& Stage1.OSIN_CAN_ATTACK);
	}

	function newRankBGColors():Void
	{
		switch (ResultsMenu.STATIC_RANK_CLASS.gradeUntranslated(ResultsMenu.STATIC_TARGET_PERCENT))
		{
			default:
				ResultsMenu.STATIC_RESULTS_BG.color = 0x3fff5c;
			case 'good' | 'great':
				ResultsMenu.STATIC_RESULTS_BG.color = 0x1aada1;
			case 'awful' | 'bad':
				ResultsMenu.STATIC_RESULTS_BG.color = 0x2456b2;
		}
	}

	override function onPostUpdate():Void
	{
		super.onPostUpdate();
		canModCredits = (CreditsSubState != null);

		TryCatch.tryCatch(() ->
		{
			if (canModCredits)
			{
				CreditsSubState.overlay.color = FlxColor.WHITE;
			}
		});
	}

	override function onPreStateCreate(state:FlxState):Void
	{
		super.onPreStateCreate(state);

		if (canModCredits)
		{
			trace('Credits Menu!');

			if (!CreditsSubState.creditsJSON.contains(coolCredits[0]))
			{
				CreditsSubState.creditsJSON.push(coolCredits[0]);
				CreditsSubState.creditsJSON.push(coolCredits[1]);
			}
		}
	}

	var coolCredits:Array<CreditsEntry> = [
		{
			text: "COOLIO MODDING",
			size: 2,
			color: [0, 0, 0],
			spacing: 100
		},
		{
			text: "SINCO",
			size: 1,
			color: [0, 0, 0],
			spacing: 50
		}
	];
}
