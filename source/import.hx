package;

import flixel.*;
import flixel.addons.display.FlxBackdrop;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.gamepad.*;
import flixel.input.keyboard.FlxKey;
import flixel.math.*;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.*;
import flixel.tweens.FlxTween.TweenCallback;
import flixel.tweens.misc.ColorTween;
import flixel.ui.FlxBar;
import flixel.util.*;
import flixel.util.typeLimit.NextState;
import flxanimate.FlxAnimate;
import funkin.graphics.shaders.*;
import haxe.*;
import haxe.io.Path;
import haxe.iterators.*;
import hscript.*;
import lime.utils.*;
import openfl.*;
import openfl.Assets as OpenFLAssets;
import openfl.display.*;
import openfl.events.*;
import openfl.geom.*;
import openfl.net.*;
import openfl.system.System;
import openfl.text.*;
import sap.*;
import sap.cutscenes.*;
import sap.localization.LocalizationManager;
import sap.medals.*;
import sap.modding.hscript.*;
import sap.plugins.*;
import sap.results.ResultsMenu;
import sap.savedata.*;
import sap.stages.StageGlobals;
import sap.utils.*;
import sap.utils.DynamicAnimationJSON.AnimData;
import sap.worldmap.*;
import sap.worldmap.PlayableCharacter;
import sinlib.*;
import sinlib.utilities.*;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end
#if DISCORDRPC
import Discord.DiscordClient;
#end
import tjson.TJSON;
