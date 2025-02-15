package;

import flixel.system.debug.log.LogStyle;
import flixel.util.typeLimit.NextState;
import lime.utils.Assets;
import sap.credits.CreditsSubState;
import sap.cutscenes.intro.IntroCutscene;
import sap.mainmenu.MainMenu;
import sap.modding.source.ModListManager;
import sap.modding.source.mods.MassMod;
import sap.results.ResultsMenu;
import sap.stages.stage1.Stage1;
import sap.stages.stage4.Stage4;
import sap.title.TitleState;
import sap.worldmap.Worldmap;
import sinlib.SLGame;

using StringTools;

// This is initalization stuff + compiler condition flags
class InitState extends FlxState
{
	override public function create()
	{
		// Make errors and warnings less annoying.
		#if DISABLE_ANNOYING_ERRORS
		LogStyle.ERROR.openConsole = false;
		LogStyle.ERROR.errorSound = null;
		#end

		#if DISABLE_ANNOYING_WARNINGS
		LogStyle.WARNING.openConsole = false;
		LogStyle.WARNING.errorSound = null;
		#end

                LanguageInit();
                ModsInit();

                CreditsSubState.creditsJSON = FileManager.getJSON(FileManager.getDataFile('credits.json'));

		if (!SLGame.isDebug) proceed();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		// when on debug builds you have to press something to stop
		if (FlxG.keys.justReleased.ANY && SLGame.isDebug)
		{
			proceed();
		}

		super.update(elapsed);
	}

	public static dynamic function proceed()
	{
		#if !DISABLE_PLUGINS
		Plugins.init();
		#end

		#if CUTSCENE_TESTING
		#elseif SKIP_TITLE
		trace('Skipping Title');
                switchToState(() -> new MainMenu(), 'MainMenu');
		return;
		#elseif STAGE_ONE
                switchToState(() -> new Stage1(), 'Stage 1');
		return;
		#elseif STAGE_FOUR
                switchToState(() -> new Stage4(), 'Stage 4');
		return;
		#elseif WORLDMAP
                switchToState(() -> new Worldmap(), 'Worldmap');
		return;
		#elseif RESULTS
                var good:Int = 0;
                var char:String = 'sinco';

                #if BAD_RANK good = 1; #end
                #if GOOD_RANK good = 6; #end
                #if GREAT_RANK good = 8; #end
                #if EXCELLENT_RANK good = 9; #end
                #if PERFECT_RANK good = 10; #end

                #if PORT_RANK_CHAR char = 'port'; #end

                switchToState(() -> new ResultsMenu(good, 10, () -> new MainMenu(), char), 'Results Menu');
		return;
		#end

		FlxG.switchState(TitleState.new);
	}

        public static function switchToState(state:NextState, stateName:String) {
		trace('Moving to $stateName');
		FlxG.switchState(state);
        }

        public function LanguageInit()
        {
                LanguageManager.LANGUAGE = SaveManager.getLanguage();

                if (FileManager.exists(FileManager.getPath('', 'cur_lang.txt')))
                {
                        LanguageManager.LANGUAGE = FileManager.readFile(FileManager.getPath('', 'cur_lang.txt'));
                }

                #if SPANISH_LANGUAGE LanguageManager.LANGUAGE = 'spanish'; #end
                #if PORTUGUESE_LANGUAGE LanguageManager.LANGUAGE = 'portuguese'; #end

                #if FORCED_ENGLISH_LANGUAGE LanguageManager.LANGUAGE = 'english'; #end

                PhraseManager.init();
        }

        public function ModsInit()
        {
                #if MASS_MOD ModListManager.addMod(new MassMod()); #end
                ModListManager.create();

                MassMod.instance.toggleEnabled();
        }
}
