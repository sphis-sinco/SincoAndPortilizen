package sap.modding.source.mods;

import flixel.util.FlxColor;
import sap.credits.CreditsEntry;
import sap.credits.CreditsSubState;
import sap.cutscenes.PanelCutscene;
import sap.cutscenes.intro.IntroCutscene;
import sap.mainmenu.MainMenu;
import sap.stages.stage1.Stage1;
import sap.stages.stage4.Stage4;
import sap.title.TitleState;
import sap.worldmap.Worldmap;
import sinlib.SLGame;

class MassMod extends ModBasic
{
	public static var instance:ModBasic;

	var canModCredits:Bool = false;

	override public function new()
	{
		super(false);

		instance = this;
	}

	override function create()
	{
		trace('Mass mod');

		TitleState.get_versiontext = function():String
		{
			return 'v.mass mod6969';
		}

		Global.change_saveslot((SLGame.isDebug) ? 'debug_massmod' : 'release_massmod');

		super.create();
	}

	override function onStateSwitchComplete()
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

			Stage1.OSIN_MAX_HEALTH = 100;
			Stage1.SINCO_MAX_HEALTH = 5;

			Stage1.OSIN_HEALTH = Stage1.OSIN_MAX_HEALTH;
			Stage1.SINCO_HEALTH = Stage1.SINCO_MAX_HEALTH;

			Stage1.getOsinJumpCondition = function():Bool
			{
				return (Stage1.SINCO_HEALTH >= 1
					&& Stage1.OSIN_HEALTH >= 1
					&& FlxG.random.int(0, 1) == 1
					&& (Stage1.osin.animation.name != 'jump' && Stage1.osin.animation.name != 'hurt')
					&& Stage1.osin_canjump);
			}

			Stage1.osin.color = FlxColor.YELLOW;
		}

		if (Global.getCurrentState() == "Stage4")
		{
			trace('Stage 4!');

                        Stage4.total_time = 120;
                        Stage4.enemyAttackCondition = function():Bool { return true; }
                        Stage4.timerText.text = Std.string(Stage4.total_time - Stage4.time);
		}
	}

	override function onPostUpdate()
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

	override function onPreStateCreate(state:FlxState)
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

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
