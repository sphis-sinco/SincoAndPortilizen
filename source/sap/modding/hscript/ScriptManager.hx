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
                LOADED_SCRIPTS = [];

		// loading scripts
		var scriptPaths:Array<String> = FileManager.getScriptArray();

		for (path in scriptPaths)
		{
			TryCatch.tryCatch(function()
			{
				var newScript:Iris = new Iris(FileManager.readFile('$path'), {name: path, autoRun: true, autoPreset: true});
				trace('New script: $path');
				LOADED_SCRIPTS.push(newScript);
			});
		}

                // utils
                setScript('Global', Global, false);

                setScript('FileManager', FileManager, false);
                setScript('DAJSprite', DAJSprite, false);
                setScript('State', State, false);
                setScript('Random', Random, false);

                // gameplay
                setScript('StageGlobals', StageGlobals, true);
                setScript('Combo', Combo, true);
                setScript('PaulPortGameOver', PaulPortGameOver, true);

                setScript('Stage1', Stage1, false);
                setScript('Stage1Sinco', Sinco, true);
                setScript('Stage1Osin', Osin, true);
                setScript('PostStage1Cutscene', PostStage1Cutscene, true);

                setScript('Stage2', Stage2, false);
                setScript('PostStage2Cutscene', PostStage2Cutscene, true);
                setScript('Stage2Rock', Stage2Rock, true);
                setScript('Stage2Sinco', Stage2Sinco, true);

                setScript('Stage4', Stage4, false);
                setScript('PostStage4Cutscene', PostStage4Cutscene, true);
                setScript('PortS4', PortS4, true);
                setScript('EnemyS4', EnemyS4, true);
                
                setScript('Sidebit1', Sidebit1, false);
                setScript('Sidebit1IntroCutsceneAtlas', Sidebit1IntroCutsceneAtlas, true);
                setScript('Sidebit1PostCutsceneAtlas', Sidebit1PostCutsceneAtlas, true);
 
                // results
                setScript('Rank', Rank, true);
                setScript('ResultsChar', ResultsChar, true);
                setScript('ResultsMenu', ResultsMenu, false);
 
                // medals
                setScript('Medal', Medal, false);
 
                // locale
                setScript('LocalizationManager', LocalizationManager, true);
 
                // cutscenes
                setScript('AtlasCutscene', AtlasCutscene, true);
                setScript('PanelCutscene', PanelCutscene, true);
                setScript('SparrowCutscene', SparrowCutscene, true);

                // menus
                setScript('CreditsSubState', CreditsSubState, true);
                setScript('SettingsMenu', SettingsMenu, true);
                setScript('SidebitSelect', SidebitSelect, true);
                setScript('MainMenu', MainMenu, true);
                setScript('PlayMenu', PlayMenu, true);
                setScript('TitleState', TitleState, true);
	}

	public static function callScript(fun:String, ?args:Array<Dynamic>):Void
	{
		for (script in LOADED_SCRIPTS)
		{
			@:privateAccess {
				var ny:Dynamic = script.interp.variables.get(fun);
				try
				{
					if (ny != null && Reflect.isFunction(ny))
						script.call(fun, args);
				}
				catch (e)
				{
					trace('error parsing script: ' + e);
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
