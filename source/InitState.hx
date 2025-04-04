package;

import flixel.system.debug.log.LogStyle;
import flixel.util.typeLimit.NextState;
import sap.credits.CreditsSubState;
import sap.mainmenu.MainMenu;
import sap.modding.source.ModListManager;
import sap.modding.source.mods.MassMod;
import sap.results.ResultsMenu;
import sap.stages.stage1.Stage1;
import sap.stages.stage2.Stage2;
import sap.stages.stage4.Stage4;
import sap.title.TitleState;
import sap.worldmap.Worldmap;

// This is initalization stuff + compiler condition flags
class InitState extends FlxState
{
	override public function create():Void
	{
		// Make errors and warnings less annoying.
		#if DISABLE_ANNOYING_ERRORS
		LogStyle.ERROR.openConsole = false;
		LogStyle.ERROR.errorSound = null;
                trace('Disabled annoying errors');
		#end

		#if DISABLE_ANNOYING_WARNINGS
		LogStyle.WARNING.openConsole = false;
		LogStyle.WARNING.errorSound = null;
                trace('Disabled annoying warnings');
		#end

                FlxG.sound.volumeUpKeys = [];
                FlxG.sound.volumeDownKeys = [];
                FlxG.sound.muteKeys = [];
                trace('Disabled volume keys');
                FileManager.FILE_MANAGER_VERSION_SUFFIX = '-SincoAndPortilizen';
                trace('FILE_MANAGER_VERSION_SUFFIX: ${FileManager.FILE_MANAGER_VERSION_SUFFIX}');

		TryCatch.tryCatch(() -> {
                        CreditsSubState.creditsJSON = FileManager.getJSON(FileManager.getDataFile('credits.json'));
                }, {
                        errFunc: () -> {
                                trace('Error while loading credits JSON');
                                CreditsSubState.creditsJSON = [
                                        {
                                                "text": "Credits could not load",
                                                "size": 10,
                                                "color": [255, 255, 255],
                                                "spacing": 500
                                        }
                                ];
                        }
                });
                trace('Loaded credits JSON');

		if (!SLGame.isDebug)
                {
                        trace('Game is not a debug build, auto-proceed');
			proceed();
                } else {
                        trace('Game is a debug build');
                }

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		// when on debug builds you have to press something to stop
		if (FlxG.keys.justReleased.ANY && SLGame.isDebug)
		{
			proceed();
		}

		super.update(elapsed);
	}

	public static dynamic function proceed():Void
	{
                trace('Proceeding');

		#if !DISABLE_PLUGINS
		Plugins.init();
                trace('Initalizing plugins');
		#end

		#if CUTSCENE_TESTING
		#elseif SKIP_TITLE
		trace('Skipping Title');
		switchToState(() -> new MainMenu(), 'MainMenu');
		return;
		#elseif STAGE_ONE
		switchToState(() -> new Stage1(), 'Stage 1');
		return;
		#elseif STAGE_TWO
		switchToState(() -> new Stage2(), 'Stage 2');
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

                trace('Starting game regularly');
		FlxG.switchState(TitleState.new);
	}

	public static function switchToState(state:NextState, stateName:String):Void
	{
		trace('Moving to $stateName');
		FlxG.switchState(state);
	}

	public static function ModsInit():Void
	{
		#if MASS_MOD
                trace('MassMod added');
                ModListManager.addMod(new MassMod());
                #end
		ModListManager.create();

		#if MASS_MOD
                MassMod.instance.toggleEnabled();
                #end
	}

	public static dynamic function LanguageInit():Void
	{
		LocalizationManager.LANGUAGE = 'english';

                TryCatch.tryCatch(() -> {
                        LocalizationManager.LANGUAGE = SaveManager.getLanguage();
                }, {
                        errFunc: () -> {
                                trace('Error while setting LANGUAGE to saved language');
                        }
                });

		if (FileManager.exists(FileManager.getPath('', 'cur_lang.txt')))
		{
			LocalizationManager.LANGUAGE = FileManager.readFile(FileManager.getPath('', 'cur_lang.txt'));
		}

		#if SPANISH_LANGUAGE
                trace('Spanish language is being forced.');
                LocalizationManager.LANGUAGE = 'spanish';
                #end
		#if PORTUGUESE_LANGUAGE
                trace('Portuguese language is being forced.');
                LocalizationManager.LANGUAGE = 'portuguese';
                #end

		#if FORCED_ENGLISH
                trace('English language is being forced.');
                LocalizationManager.LANGUAGE = 'english';
                #end

		LocalizationManager.changeLanguage();
	}
}
