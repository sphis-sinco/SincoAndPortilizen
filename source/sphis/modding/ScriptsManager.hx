package modding;

import sphis.defines.DefineManager;
#if hscriptIris
import crowplexus.iris.Iris;
import flixel.*;
import flixel.animation.*;
import flixel.effects.FlxFlicker;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.*;
import flixel.group.*;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.keyboard.*;
import flixel.input.mouse.FlxMouse;
import flixel.math.*;
import flixel.text.*;
import flixel.tweens.*;
import flixel.util.*;
import flixel.util.typeLimit.NextState;
import haxe.PosInfos;
import play.*;
#if hscript
import hscript.*;
#end
#if sys
import sys.FileSystem;
import sys.io.File;
#end

// THANK YOU FNF-Doido-Engine
class ScriptsManager {
	// hscript!!
	public static var LOADED_SCRIPTS:Array<Iris> = [];

	private static function loadScripts():Void {
		// NO DUPES
		for (instance in LOADED_SCRIPTS) {
			// fix multiple instances of similar scripts
			// trace('Bye bye ${instance.name}');
			instance.destroy();
		}
		LOADED_SCRIPTS = [];

		// loading scripts
		var scriptPaths:Array<String> = [];
		var readDirectory = function(dir:String) {}

		readDirectory = function(dir:String) {
			// trace(dir);
			#if sys
			if (!FileSystem.exists(dir))
				return;
			for (file in FileSystem.readDirectory(dir)) {
				if (file.endsWith(sphis.Assets.HSCRIPT_EXT)) {
					if (!scriptPaths.contains('$dir/$file'))
						scriptPaths.push('$dir/$file');
				} else if (!file.contains('.')) {
					readDirectory('$dir/$file');
				}
			}
			#end
		}
		readDirectory(sphis.Assets.getAssetPath('scripts'));
		readDirectory('assets/scripts');

		for (path in scriptPaths) {
			#if sys
			var newScript:Iris = new Iris(File.getContent(path), {name: path, autoRun: true, autoPreset: true});
			if (LOADED_SCRIPTS.contains(newScript))
				return;
			// FlxG.log.add('New script: $path');
			LOADED_SCRIPTS.push(newScript);
			#end
		}

		// import stuff
		#if sys
		setScript('FileSystem', FileSystem);
		setScript('File', File);
		#end

		setScript('Assets', sphis.Assets);
		setScript('DefineManager', sphis.defines.DefineManager);
		setScript('ScriptsManager', sphis.modding.ScriptsManager);

		setScript("FlxG", FlxG);
		setScript("FlxGraphic", FlxGraphic);
		setScript("FlxSprite", FlxSprite);
		setScript("FlxObject", FlxObject);
		setScript("FlxBasic", FlxBasic);
		setScript("FlxState", FlxState);
		setScript("FlxCamera", FlxCamera);
		setScript("FlxGame", FlxGame);

		// Groups
		setScript("FlxGroup", flixel.group.FlxGroup);
		setScript("FlxContainer", FlxContainer);

		// Animation
		setScript("FlxAnimation", FlxAnimation);
		setScript("FlxAnimationController", FlxAnimationController);
		setScript("FlxAtlasFrames", FlxAtlasFrames);
		setScript("FlxTileFrames", FlxTileFrames);
		setScript("FlxFrame", FlxFrame);

		// Math
		setScript("FlxAngle", FlxAngle);
		setScript("FlxRect", FlxRect);
		setScript("FlxMath", FlxMath);
		setScript("FlxRandom", FlxRandom);

		// Text
		setScript("FlxText", FlxText);
		setScript("FlxInputText", FlxInputText);

		// Input
		setScript("FlxMouse", FlxMouse);
		setScript("FlxKeyboard", FlxKeyboard);
		setScript("FlxGamepad", FlxGamepad);

		// Utilities
		setScript("FlxSave", FlxSave);
		setScript("FlxTimer", FlxTimer);
		setScript("FlxSort", FlxSort);

		#if (!js || !html5)
		#if flixelModding
		setScript("FlxModding", flixel.system.FlxModding);
		#end
		#end

		// Tweens
		setScript("FlxTween", FlxTween);
		setScript("FlxEase", FlxEase);

		// Effects
		setScript("FlxFlicker", FlxFlicker);

		// script exclusive stuff
		setScript('is_debug', DefineManager.DEFINES.contains('debug'));
		setScript('colorFromString', function(string:String) {
			return FlxColor.fromString(string);
		});
		setScript('switchState', function(nextState:NextState) {
			FlxG.switchState(nextState);
		});

		// init mod

		callScript('scriptsLoaded');
	}

	public static function callScript(fun:String, ?args:Array<Dynamic>, ?endCallBack:Void->Void, ?pos:haxe.PosInfos):Void {
		for (script in LOADED_SCRIPTS) {
			@:privateAccess {
				var ny:Dynamic = script.interp.variables.get(fun);
				try {
					if (ny != null && Reflect.isFunction(ny)) {
						script.call(fun, args);
						// trace('ran $fun with args $args', pos);
					}
				} catch (e) {
					trace('error parsing script: ' + e, pos);
				}
			}
		}

		if (endCallBack != null)
			endCallBack();
	}

	public static function setScript(name:String, value:Dynamic, allowOverride:Bool = true):Void {
		for (script in LOADED_SCRIPTS)
			script.set(name, value, allowOverride);
	}
}
#else
class ScriptsManager {
	public static var LOADED_SCRIPTS:Array<Dynamic> = [];

	private static function loadScripts():Void {
		trace('hscriptIris define not defined');
	}

	public static function callScript(fun:String, ?args:Array<Dynamic>, ?endCallBack:Void->Void, ?pos:haxe.PosInfos):Void {
		trace('hscriptIris define not defined');
	}

	public static function setScript(name:String, value:Dynamic, allowOverride:Bool = true):Void {
		trace('hscriptIris define not defined');
	}
}
#end
