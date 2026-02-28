package;

import flixel.util.typeLimit.NextState;
import lime.app.Application;
import flixel.util.FlxSignal;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;
import flixel.sound.FlxSound;
import lime.utils.Assets as LimeAssets;

using StringTools;

class Global
{
	public static var previousState:String;

	public static var GENERATED_BY(get, never):String;
	static inline var GENERATED_BY_PREFIX = 'Sinco and Portilizen';

	static function get_GENERATED_BY():String
		return '${GENERATED_BY_PREFIX} v${VERSION}';

	public static var VERSION(get, never):String;

	public static dynamic function get_VERSION():String
	{
		return Application.current.meta.get('version');
	}

	public static var DEFAULT_IMAGE_SCALE_MULTIPLIER:Float = 4.0;

	public static var SAVE_SLOT:Dynamic = 1;
	public static var SAVE_SLOT_PREFIX:String = 'SAP';
	public static var SAVE_SLOT_SUFFIX:Dynamic = 1;

	public static function SAVE_BACKWARDS_COMPATABILITY():Void
	{
		try
		{
			//  backwards compatability
			if (FlxG.save.data.levels_complete.contains(1))
			{
				FlxG.save.data.levels_complete.remove(1);
				Global.beatLevel(MedalStrings.STRING_QUEST);
			}
			if (FlxG.save.data.levels_complete.contains(2))
			{
				FlxG.save.data.levels_complete.remove(2);
				Global.beatLevel(MedalStrings.OSIN);
			}
			if (FlxG.save.data.levels_complete.contains(3))
			{
				FlxG.save.data.levels_complete.remove(3);
				Global.beatLevel(MedalStrings.TRES);
			}

			if (FlxG.save.data.levels_complete.contains(MedalStrings.STRING_QUEST)
				|| FlxG.save.data.medals.contains(MedalStrings.STRING_QUEST))
				Global.unlockMedal(MedalStrings.STRING_QUEST);
			if (FlxG.save.data.levels_complete.contains(MedalStrings.OSIN) || FlxG.save.data.medals.contains(MedalStrings.OSIN))
				Global.unlockMedal(MedalStrings.OSIN);
			if (FlxG.save.data.levels_complete.contains(MedalStrings.TRES) || FlxG.save.data.medals.contains(MedalStrings.TRES))
				Global.unlockMedal(MedalStrings.TRES);

			if (FlxG.save.data.medals.contains(MedalStrings.PROGRAMMER))
				Global.unlockMedal(MedalStrings.PROGRAMMER);
		}
		catch (_:Dynamic) {}
	}

	public static function change_saveslot(slotsuffix:Dynamic = 1):Void
	{
		SAVE_SLOT_SUFFIX = slotsuffix;
		SAVE_SLOT = '$SAVE_SLOT_PREFIX-$SAVE_SLOT_SUFFIX';
		FlxG.save.bind(SAVE_SLOT, 'SAPTeam');
		trace('Switched save slot to "$SAVE_SLOT"');

		// Initialize defaults once
		var d:Dynamic = FlxG.save.data;
		if (d.volume == null)
			d.volume = 1.0;
		if (d.discord_rpc == null)
			d.discord_rpc = true;
		if (d.levels_complete == null)
			d.levels_complete = [];
		if (d.medals == null)
			d.medals = [];
		if (d.colored_levelSelect == null)
			d.colored_levelSelect = false;

		SAVE_BACKWARDS_COMPATABILITY();
		// Persist immediately to avoid data loss if the app closes early
		try
			FlxG.save.flush()
		catch (_:Dynamic) {}

		trace('Save dump: ${FlxG.save.data}');
	}

	public static function createTrail(sprite:FlxSprite, xEnd:Float, delay:Float, speed:Float, max:Int)
	{
		var trails = new FlxSpriteGroup(0, 0, max);

		new FlxTimer().start(delay, function(timer:FlxTimer)
		{
			var trail = sprite.clone();
			trail.setPosition(sprite.x, sprite.y);
			trail.alpha = 0.7;
			trails.add(trail);

			FlxTween.tween(trail, {x: sprite.x + xEnd, alpha: 0}, speed, {
				onComplete: tween ->
				{
					trails.remove(trail);
				}
			});

			timer.reset(delay);
		});
		return trails;
	}

	public static function scaleSprite(sprite:FlxSprite, ?addition:Float = 0, centerOrigin:Bool = true, pixelPerfect:Bool = true):FlxSprite
	{
		var s = DEFAULT_IMAGE_SCALE_MULTIPLIER + (addition != null ? addition : 0);
		sprite.scale.set(s, s);
		if (centerOrigin)
			sprite.centerOrigin();
		sprite.updateHitbox();
		if (pixelPerfect)
		{
			sprite.x = Math.fround(sprite.x);
			sprite.y = Math.fround(sprite.y);
		}
		return sprite;
	}

	public static function scaleSpriteToHeight(sprite:FlxSprite, targetHeight:Float, centerOrigin:Bool = true):FlxSprite
	{
		if (sprite.frameHeight <= 0)
			return sprite;
		var s = targetHeight / sprite.frameHeight;
		sprite.scale.set(s, s);
		if (centerOrigin)
			sprite.centerOrigin();
		sprite.updateHitbox();
		return sprite;
	}

	// Track last requested music path to avoid redundant restarts
	static var __lastMusicId:String = null;

	public static function playMenuMusic():Void
		playMusic('MenuTracks/Lado');

	/**
	 * Play a music track if nothing is playing; does not force a restart.
	 */
	public static function playMusic(filename:String):Void
	{
		var path = Assets.getMusicPath(filename);
		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
			{
				__lastMusicId = path;
				FlxG.sound.playMusic(path);
			}
		}
		else
		{
			__lastMusicId = path;
			FlxG.sound.playMusic(path);
		}
	}

	public static function fadeToMusic(filename:String, volume:Float = 1.0, fadeOut:Float = 0.35, fadeIn:Float = 0.5, onlyIfDifferent:Bool = true):Void
	{
		var path = Assets.getMusicPath(filename);
		if (onlyIfDifferent && __lastMusicId == path && FlxG.sound.music != null && FlxG.sound.music.playing)
		{
			// Update volume if needed but avoid restart
			FlxG.sound.music.volume = volume;
			return;
		}

		var startNew = function()
		{
			__lastMusicId = path;
			FlxG.sound.playMusic(path, volume, true);
			if (fadeIn > 0 && FlxG.sound.music != null)
			{
				var m = FlxG.sound.music;
				var old = m.volume;
				m.volume = 0;
				m.fadeIn(fadeIn, 0, old);
			}
		};

		if (FlxG.sound.music != null && FlxG.sound.music.playing && fadeOut > 0)
		{
			FlxG.sound.music.fadeOut(fadeOut, function(_) startNew());
		}
		else
		{
			startNew();
		}
	}

	public static function playSoundEffect(name:String, volume:Float = 1.0):Void
		FlxG.sound.play(Assets.getSoundPath(name), volume);

	public static function hitHurt():Void
		playSoundEffect('gameplay/hitHurt/hitHurt-${FlxG.random.int(1, 4)}');

	public static function setMasterVolume(vol:Float):Void
	{
		var v = Math.max(0, Math.min(1, vol));
		FlxG.sound.volume = v;
		if (FlxG.save.data != null)
		{
			FlxG.save.data.volume = v;
			try
				FlxG.save.flush()
			catch (_:Dynamic) {}
		}
	}

	public static function beatLevel(lvl:String = ''):Void
	{
		#if !html5
		if (!FlxG.save.data.levels_complete.contains(lvl))
			FlxG.save.data.levels_complete.push(lvl);
		#end

		if (!WebSave.levels_complete.contains(lvl))
			WebSave.levels_complete.push(lvl);

		try
			FlxG.save.flush()
		catch (_:Dynamic) {}
	}

	public static function unlockMedal(medal:String = ''):Void
	{
		#if !html5
		if (!FlxG.save.data.medals.contains(medal))
		{
			FlxG.save.data.medals.push(medal);
			trace('Unlocked ${medal} into the Save data');
		}
		else
		{
			trace('${medal} already unlocked in the Save data');
		}
		#end

		if (!WebSave.medals.contains(medal))
		{
			trace('Unlocked ${medal} into WebSave');
			WebSave.medals.push(medal);
		}
		else
		{
			trace('${medal} already unlocked in WebSave');
		}

		try
			FlxG.save.flush()
		catch (_:Dynamic) {}
	}

	public static function changeDiscordRPCPresence(state:String = null, details:Null<String> = null):Void
	{
		#if !DISCORDRPC
		return;
		#else
		trace('Discord presence is being changed (details: ${details}, state: ${state})');
		DiscordClient.changePresence(details, state);
		#end
	}

	public static function getCurrentState():String
	{
		if (FlxG.state == null)
			return 'Unknown';
		var cls = Type.getClass(FlxG.state);
		if (cls == null)
			return 'Unknown';
		var name = Type.getClassName(cls);
		return name != null ? name.split('.').pop() : 'Unknown';
	}

	public static function switchState(new_state:FlxState):Void
	{
		previousState = getCurrentState();
		FlxG.switchState(() -> new_state);
	}

	public static function switchStateFn(make:NextState):Void
	{
		previousState = getCurrentState();
		FlxG.switchState(make);
	}

	/* ───────────────────────────── Input Sugar ───────────────────────────────── */
	// I like this comment

	public static inline function anyKeysPressed(keys:Array<FlxKey>):Bool
		return FlxG.keys.anyPressed(keys);

	public static inline function keyPressed(key:FlxKey):Bool
		return anyKeysPressed([key]);

	public static inline function anyKeysJustReleased(keys:Array<FlxKey>):Bool
		return FlxG.keys.anyJustReleased(keys);

	public static inline function keyJustReleased(key:FlxKey):Bool
		return anyKeysJustReleased([key]);

	public static inline function anyKeysJustPressed(keys:Array<FlxKey>):Bool
		return FlxG.keys.anyJustPressed(keys);

	public static inline function keyJustPressed(key:FlxKey):Bool
		return anyKeysJustPressed([key]);

	public static function dummyBG(colorRGB:Array<Int>, w:Null<Int> = null, h:Null<Int> = null):Spr
	{
		var background:Spr = new Spr();
		var r = colorSafe(colorRGB, 0);
		var g = colorSafe(colorRGB, 1);
		var b = colorSafe(colorRGB, 2);
		background.makeGraphic((w != null) ? w : Std.int(FlxG.width / 4), (h != null) ? h : Std.int(FlxG.height / 4),
			FlxColor.fromRGB(colorRGB[0], colorRGB[1], colorRGB[2]));
		background.scaleSpr();
		background.screenCenter();
		return background;
	}

	static inline function colorSafe(arr:Array<Int>, i:Int):Int
		return (arr != null && i >= 0 && i < arr.length) ? Std.int(Math.max(0, Math.min(255, arr[i]))) : 0;

	public static function camflash(Color:FlxColor = FlxColor.WHITE, Duration:Float = 1, ?OnComplete:Void->Void, Force:Bool = false):Void
	{
		if (FlxG.state != null && FlxG.state.camera != null)
		{
			FlxG.state.camera.flash(Color, Duration, OnComplete, Force);
		}
		else if (FlxG.camera != null)
		{
			FlxG.camera.flash(Color, Duration, OnComplete, Force);
		}
	}

	public static function camshake(intensity:Float = 0.01, duration:Float = 0.3):Void
	{
		if (FlxG.state != null && FlxG.state.camera != null)
		{
			FlxG.state.camera.shake(intensity, duration);
		}
		else if (FlxG.camera != null)
		{
			FlxG.camera.shake(intensity, duration);
		}
	}
}
