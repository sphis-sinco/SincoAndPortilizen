package sap.modding.hscript;

import crowplexus.iris.Iris;
import sap.credits.CreditsSubState;
import sap.mainmenu.MainMenu;
import sap.mainmenu.PlayMenu;
import sap.results.Rank;
import sap.results.ResultsChar;
import sap.settings.SettingsMenu;
import sap.sidebitmenu.SidebitSelect;
import sap.stages.Combo;
import sap.stages.PaulPortGameOver;
import sap.stages.sidebit1.Sidebit1;
import sap.stages.sidebit1.Sidebit1IntroCutsceneAtlas;
import sap.stages.sidebit1.Sidebit1PostCutsceneAtlas;
import sap.stages.stage1.Osin;
import sap.stages.stage1.PostStage1Cutscene;
import sap.stages.stage1.Sinco;
import sap.stages.stage1.Stage1;
import sap.stages.stage2.PostStage2Cutscene;
import sap.stages.stage2.Stage2;
import sap.stages.stage2.Stage2Rock;
import sap.stages.stage2.Stage2Sinco;
import sap.stages.stage4.EnemyS4;
import sap.stages.stage4.PortS4;
import sap.stages.stage4.PostStage4Cutscene;
import sap.stages.stage4.Stage4;
import sap.title.TitleState;

// THANK YOU FNF-Doido-Engine
class ScriptManager
{
	// hscript!!
	public static var LOADED_SCRIPTS:Array<Iris> = [];

	public static function loadScripts():Void
	{
		// NO DUPES
                for (instance in LOADED_SCRIPTS)
                {
                        // fix multiple instances of similar scripts
                        instance.destroy();
                }
		LOADED_SCRIPTS = [];

		// loading scripts
		var scriptPaths:Array<String> = FileManager.getScriptArray();

		for (path in scriptPaths)
		{
			TryCatch.tryCatch(function()
			{
				var newScript:Iris = new Iris(FileManager.readFile('$path'), {name: path, autoRun: true, autoPreset: true});
				#if EXCESS_TRACES
				trace('New script: $path');
				#end
				LOADED_SCRIPTS.push(newScript);
			});
		}

		// utils
		setScript('Global', Global);

		setScript('FileManager', FileManager);
		setScript('DAJSprite', DAJSprite);
		setScript('State', State);
		setScript('Random', Random);

		setScript('BlankBG', BlankBG);

		// gameplay
		setScript('StageGlobals', StageGlobals);
		setScript('Combo', Combo);
		setScript('PaulPortGameOver', PaulPortGameOver);

		setScript('Stage1', Stage1);
		setScript('Stage1Sinco', Sinco);
		setScript('Stage1Osin', Osin);
		setScript('PostStage1Cutscene', PostStage1Cutscene);

		setScript('Stage2', Stage2);
		setScript('PostStage2Cutscene', PostStage2Cutscene);
		setScript('Stage2Rock', Stage2Rock);
		setScript('Stage2Sinco', Stage2Sinco);

		setScript('Stage4', Stage4);
		setScript('PostStage4Cutscene', PostStage4Cutscene);
		setScript('PortS4', PortS4);
		setScript('EnemyS4', EnemyS4);

		setScript('Sidebit1', Sidebit1);
		setScript('Sidebit1IntroCutsceneAtlas', Sidebit1IntroCutsceneAtlas);
		setScript('Sidebit1PostCutsceneAtlas', Sidebit1PostCutsceneAtlas);

		// results
		setScript('Rank', Rank);
		setScript('ResultsChar', ResultsChar);
		setScript('ResultsMenu', ResultsMenu);

		// medals
		setScript('Medal', Medal);
		setScript('MedalsMenu', MedalsMenu);

		// locale
		setScript('LocalizationManager', LocalizationManager);

		// cutscenes
		setScript('AtlasCutscene', AtlasCutscene);
		setScript('PanelCutscene', PanelCutscene);
		setScript('SparrowCutscene', SparrowCutscene);

		// menus
		setScript('CreditsSubState', CreditsSubState);
		setScript('SettingsMenu', SettingsMenu);
		setScript('SidebitSelect', SidebitSelect);
		setScript('MainMenu', MainMenu);
		setScript('PlayMenu', PlayMenu);
		setScript('TitleState', TitleState);

                // custom
		setScript('UnlockMedal', function(medal:String):Medal {
                        return MedalData.unlockMedal(medal);
                });

                // init mod
                ScriptManager.callScript('initalizeMod');
	}

	public static function callScript(fun:String, ?args:Array<Dynamic>, ?pos: haxe.PosInfos):Void
	{
		for (script in LOADED_SCRIPTS)
		{
			@:privateAccess {
				var ny:Dynamic = script.interp.variables.get(fun);
				try
				{
					if (ny != null && Reflect.isFunction(ny))
					{
						script.call(fun, args);
                                                // trace('ran $fun with args $args', pos);
					}
				}
				catch (e)
				{
					trace('error parsing script: ' + e, pos);
				}
			}
		}
	}

	public static function setScript(name:String, value:Dynamic, allowOverride:Bool = true):Void
	{
		for (script in LOADED_SCRIPTS)
			script.set(name, value, allowOverride);
	}
}
