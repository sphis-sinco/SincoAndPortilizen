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
import sinlib.utilities.FileManager.PathTypes;

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

                

		// import stuff
<<<<<<< HEAD
		#if sys
		setScript('FileSystem', FileSystem);
		setScript('File', File);
		#end
		#if DISCORDRPC
		setScript('DiscordClient', Discord.DiscordClient);
		#end
=======
                #if sys
                setScript('FileSystem', FileSystem);
                setScript('File', File);
                #end
                #if DISCORDRPC
                setScript('DiscordClient', Discord.DiscordClient);
                #end
>>>>>>> 781357c1f1efb9a48ab96e68bc9b6d17391f6acb

		setScript('Global', Global);

		setScript('FileManager', FileManager);
		setScript('DAJSprite', DAJSprite);
		setScript('State', State);
		setScript('Random', Random);

		setScript('BlankBG', BlankBG);

                // functions
		setScript('UnlockMedal', function(medal:String):Medal {
                        return MedalData.unlockMedal(medal);
                });
		setScript('PlaySFX', function(soundEffect:String, PATH_TYPE:PathTypes):Void {
                        Global.playSoundEffect(soundEffect, PATH_TYPE);
                });
		setScript('PlayMusic', function(filename:String, ?volume:Float = 1.0, ?loop:Bool = false):Void {
                        Global.playMusic(filename, volume, loop);
                });

		// init mod
		ScriptManager.callScript('initalizeMod');
	}

	public static function callScript(fun:String, ?args:Array<Dynamic>, ?pos:haxe.PosInfos):Void
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
