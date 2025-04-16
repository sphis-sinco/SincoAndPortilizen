package;

import flixel.system.debug.log.LogStyle;
import flixel.util.typeLimit.NextState;
import openfl.utils.AssetCache;
import sap.credits.CreditsSubState;
import sap.mainmenu.MainMenu;
import sap.outdated.OutdatedCheck;
import sap.outdated.OutdatedMenu;
import sap.results.ResultsMenu;
import sap.stages.PaulPortGameOver;
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
		Timer.measure(function()
		{
			trace('init');
			InitState.ModsInit();
			InitState.LanguageInit();

			// Set the saveslot to a debug saveslot or a release saveslot
			Global.change_saveslot((SLGame.isDebug) ? 'debug' : 'release');

			#if DISCORDRPC
			if (FlxG.save.data.settings.discord_rpc)
			{
				Discord.DiscordClient.initialize();
			}
			else
			{
				Discord.DiscordClient.shutdown();
			}
			#end

			#if web
			// pixel perfect render fix!
			Application.current.window.element.style.setProperty("image-rendering", "pixelated");
			#end

			// Make errors and warnings less annoying.
			#if DISABLE_ANNOYING_ERRORS
			LogStyle.ERROR.openConsole = false;
			LogStyle.ERROR.errorSound = null;
			#end

			#if DISABLE_ANNOYING_WARNINGS
			LogStyle.WARNING.openConsole = false;
			LogStyle.WARNING.errorSound = null;
			#end

			FlxG.sound.volumeUpKeys = [];
			FlxG.sound.volumeDownKeys = [];
			FlxG.sound.muteKeys = [];
			FileManager.FILE_MANAGER_VERSION_SUFFIX = '-SincoAndPortilizen';
			#if EXCESS_TRACES
			#if DISABLE_ANNOYING_ERRORS
			trace('Disabled annoying errors');
			#end
			#if DISABLE_ANNOYING_WARNINGS
			trace('Disabled annoying warnings');
			#end
			trace('Disabled volume keys');
			trace('FILE_MANAGER_VERSION_SUFFIX: "${FileManager.FILE_MANAGER_VERSION_SUFFIX}"');
			#end

			CreditsSubState.creditsJSONInit();

			// PaulPortGameOver.init();
		});

		var outdated:Bool = OutdatedCheck.checkForOutdatedVersion();
		#if html5 outdated = false; #end

		if (outdated && !OutdatedMenu.BEGONE)
		{
			trace('OUTDATED');
			FlxG.switchState(() -> new OutdatedMenu());
		}

		if (!SLGame.isDebug)
		{
			#if EXCESS_TRACES
			trace('Game is not a debug build, auto-proceed');
			#end
			proceed();
		}
		else
		{
			#if EXCESS_TRACES
			if (SLGame.isDebug)
			{
				trace('Game is a debug build');
			}
			#end
		}

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		// when on debug builds you have to press something to stop
		if (Global.keyJustReleased(ANY) && SLGame.isDebug)
		{
			proceed();
		}

		super.update(elapsed);
	}

	public static function proceed():Void
	{
		var difficulty:String = 'normal';

		#if EASY_DIFFICULTY
		difficulty = 'easy';
		#end
		#if HARD_DIFFICULTY
		difficulty = 'hard';
		#end
		#if EXTREME_DIFFICULTY
		difficulty = 'extreme';
		#end

		trace('Proceeding');
		SaveManager.setupSave();

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
		switchToState(() -> new Stage1(difficulty), 'Stage 1');
		return;
		#elseif STAGE_TWO
		switchToState(() -> new Stage2(difficulty), 'Stage 2');
		return;
		#elseif STAGE_FOUR
		switchToState(() -> new Stage4(difficulty), 'Stage 4');
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
		#elseif GIF_PORT_GAMEOVER
		switchToState(() -> new sap.stages.PaulPortGameOver(), 'PaulPortGameOver');
		return;
		#elseif SIDEBIT1_INTRO_CUTSCENE
		switchToState(() -> new sap.stages.sidebit1.Sidebit1IntroCutscene(), 'Sidebit1IntroCutscene');
		return;
		#elseif FLXANIMATE_TESTING
		switchToState(() -> new sap.stages.sidebit1.Sidebit1IntroCutsceneAtlas(), 'Sidebit1IntroCutsceneAtlas');
		return;
		#elseif SIDEBIT_ONE
		switchToState(() -> new sap.stages.sidebit1.Sidebit1IntroCutsceneAtlas(difficulty), 'Sidebit 1');
		return;
		#elseif SIDEBIT_ONE_INSTANT
		switchToState(() -> new sap.stages.sidebit1.Sidebit1(difficulty), 'Sidebit 1');
		return;
		#elseif SIDEBIT_MENU
		switchToState(() -> new sap.sidebitmenu.SidebitSelect(), 'Sidebit Select');
		return;
		#end

		trace('Starting game regularly');

		if (SLGame.isDebug)
		{
			final folder:String = Global.randomStickerFolder();
			Global.switchState(new TitleState(), false, folder, Global.randomStickerPack(folder));
			return;
		}

		FlxG.switchState(TitleState.new);
	}

	public static function switchToState(state:NextState, stateName:String):Void
	{
		trace('Moving to $stateName');
		FlxG.switchState(state);
	}

	public static function ModsInit():Void
	{
		Timer.measure(function()
		{
			trace('mods init');

			trace('Hscript mods');
			ModFolderManager.makeSupportedModdingApiVersions();
			ModFolderManager.readModFolder();

			ScriptManager.loadScripts();
		});
	}

	public static function LanguageInit():Void
	{
		Timer.measure(function()
		{
			trace('language init');
			LocalizationManager.LANGUAGE = 'english';

			TryCatch.tryCatch(() ->
			{
				LocalizationManager.LANGUAGE = SaveManager.getLanguage();
			}, {
					errFunc: () ->
					{
						trace('Error while setting LANGUAGE to saved language');
					}
			});

			if (FileManager.exists(FileManager.getPath('', 'cur_lang.txt')))
			{
				LocalizationManager.LANGUAGE = FileManager.readFile(FileManager.getPath('', 'cur_lang.txt'));
			}

			ScriptManager.callScript('initalizeLanguage');

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
		});
	}
}
