package sap.modding.hscript;

import sap.stages.sidebit2.Sidebit2IntroCutscene;
import crowplexus.iris.Iris;
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
		#if sys
		setScript('FileSystem', FileSystem);
		setScript('File', File);
		#end
		#if DISCORDRPC
		setScript('DiscordClient', Discord.DiscordClient);
		#end

		setScript('Global', Global);

		setScript('FileManager', FileManager);
		setScript('DAJSprite', DAJSprite);
		setScript('State', State);
		setScript('Random', Random);

		setScript('BlankBG', BlankBG);

		setScript('Version', Version);

		// setScript('Sidebit2IntroCutscene', Sidebit2IntroCutscene);

		// functions
		setScript('UnlockMedal', function(medal:String):Medal
		{
			return MedalData.unlockMedal(medal);
		});
		setScript('PlaySFX', function(soundEffect:String, PATH_TYPE:PathTypes):Void
		{
			Global.playSoundEffect(soundEffect, PATH_TYPE);
		});
		setScript('PlayMusic', function(filename:String, ?volume:Float = 1.0, ?loop:Bool = false):Void
		{
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
