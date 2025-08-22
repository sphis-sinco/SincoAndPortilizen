package;

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

/**
 * Global utility hub for app/build metadata, save-slot handling, audio helpers,
 * simple input sugar, and quick UI helpers.
 *
 * Backwards compatible with existing calls, but expanded with:
 * - safer version/build getters with caching & fallbacks
 * - flexible music control (fade, volume, only-if-different)
 * - quick camera effects (flash/shake)
 * - stronger save-slot bootstrap & flushing
 * - improved sprite scaling helpers (center/origin/pixel-perfect)
 * - safer current state detection
 */
// Thank you wonderinglostsoul44
class Global
{
	/** Name of the last state class before a switch. */
	public static var previousState:String;

	/* ───────────────────────────── App / Build Info ───────────────────────────── */
	public static var GENERATED_BY(get, set):String;
	static inline var _GENERATOR_PREFIX = 'Sinco and Portilizen';
	static var __versionCache:Null<String> = null;
	static var __buildCache:Null<Int> = null;

	static function get_GENERATED_BY():String
		return '${_GENERATOR_PREFIX} v${VERSION} (b${BUILD})';

	static inline function set_GENERATED_BY(v:String):String
		return v; // allow external override if desired

	/** Human version string (read once & cached). */
	public static var VERSION(get, never):String;

	public static dynamic function get_VERSION():String
	{
		if (__versionCache != null)
			return __versionCache;
		var v = '0.0.0';
		try
		{
			// Prefer lime asset pipeline (works on native/HTML5)
			if (LimeAssets.exists('version.txt'))
			{
				v = LimeAssets.getText('version.txt').trim();
			}
		}
		catch (e:Dynamic) {}
		__versionCache = v;
		return v;
	}

	/** Numeric build (read once & cached). */
	public static var BUILD(get, never):Int;

	public static dynamic function get_BUILD():Int
	{
		if (__buildCache != null)
			return __buildCache;
		var b = 0;
		try
		{
			// Project-specific Assets helper may be present; fallback to lime
			var raw:String = null;
			#if (cpp || hl || neko || js)
			try
				raw = Assets.getFileTextContent('build.txt', false)
			catch (_:Dynamic) {}
			#end
			if (raw == null && LimeAssets.exists('build.txt'))
				raw = LimeAssets.getText('build.txt');
			if (raw != null)
			{
				var parsed = Std.parseInt(raw.trim());
				if (parsed != null)
					b = parsed;
			}
		}
		catch (e:Dynamic) {}
		__buildCache = b;
		return b;
	}

	/* ───────────────────────────── Visual Defaults ───────────────────────────── */
	public static var DEFAULT_IMAGE_SCALE_MULTIPLIER:Float = 4.0;

	/* ───────────────────────────── Save Slot System ──────────────────────────── */
	public static var SAVE_SLOT:Dynamic = 1;
	public static var SAVE_SLOT_PREFIX:String = 'SAP';
	public static var SAVE_SLOT_SUFFIX:Dynamic = 1;

	/**
	 * Bind a new save slot and ensure default keys exist.
	 * @param slotsuffix e.g. profile index (1..N) or string tag
	 */
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
		else
		{
			//  backwards compatability

			if (d.levels_complete.contains(1))
			{
				d.levels_complete.remove(1);
				d.levels_complete.push('string-quest');
			}
			if (d.levels_complete.contains(2))
			{
				d.levels_complete.remove(2);
				d.levels_complete.push('osin');
			}
			if (d.levels_complete.contains(3))
			{
				d.levels_complete.remove(3);
				d.levels_complete.push('tres');
			}
		}
		if (d.medals == null)
			d.medals = [];
		if (d.colored_levelSelect == null)
			d.colored_levelSelect = false;

		// Persist immediately to avoid data loss if the app closes early
		try
			FlxG.save.flush()
		catch (_:Dynamic) {}

		trace('Save dump: ${FlxG.save.data}');
	}

	/* ───────────────────────────── Sprite Helpers ────────────────────────────── */
	/**
	 * Creates a trail similar to that of the roaring knight from Deltarune
	 * @param sprite the sprite you wish to have this effect
	 * @param xEnd when the trail sprites get deleted
	 * @param delay how long until each trail sprite spawns
	 * @param speed How fast the trail sprites go
	 * @param max how many trail sprites you want
	 */
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

	/**
	 * Scale a sprite by DEFAULT_IMAGE_SCALE_MULTIPLIER plus optional addition.
	 * Optionally centers origin and performs pixel-perfect rounding after scaling.
	 */
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

	/**
	 * Scale sprite to *fit height* (preserve aspect), then update hitbox.
	 */
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

	/* ───────────────────────────── Music / SFX Helpers ───────────────────────── */
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

	/**
	 * Fade out current track (if any) and fade in the new one.
	 * @param filename asset key/path
	 * @param volume target volume [0..1]
	 * @param fadeOut seconds to fade out old music
	 * @param fadeIn seconds to fade in new music
	 * @param onlyIfDifferent if true, will not restart same track
	 */
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

	/**
	 * Quick SFX play with optional volume (0..1). Uses project Assets helper.
	 */
	public static function playSoundEffect(name:String, volume:Float = 1.0):Void
		FlxG.sound.play(Assets.getSoundPath(name), volume);

	public static function hitHurt():Void
		playSoundEffect('gameplay/hitHurt/hitHurt-${FlxG.random.int(1, 4)}');

	/**
	 * Global master volume helper with clamping and save persistence.
	 */
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

	/* ───────────────────────────── Progress / WebSave ────────────────────────── */
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

	public static function unlockMedal(medal:String = '', ngID:Int = 0):Void
	{
		#if NEWGROUNDS
		NGio.unlockMedal(ngID);
		#end

		#if !html5
		if (!FlxG.save.data.medals.contains(medal))
			FlxG.save.data.medals.push(medal);
		#end

		if (!WebSave.medals.contains(medal))
			WebSave.medals.push(medal);

		try
			FlxG.save.flush()
		catch (_:Dynamic) {}
	}

	/* ───────────────────────────── Discord RPC ───────────────────────────────── */
	public static function changeDiscordRPCPresence(state:String = null, details:Null<String> = null):Void
	{
		#if !DISCORDRPC
		return;
		#else
		trace('Discord presence is being changed (details: ${details}, state: ${state})');
		DiscordClient.changePresence(details, state);
		#end
	}

	/* ───────────────────────────── State Helpers ─────────────────────────────── */
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

	/**
	 * Switch to a new state *instance* and record previous state's class name.
	 * If you use factories, prefer `switchStateFn` below.
	 */
	public static function switchState(new_state:FlxState):Void
	{
		previousState = getCurrentState();
		FlxG.switchState(() -> new_state);
	}

	/**
	 * Switch using a factory function (() -> FlxState). Avoids capturing an old instance.
	 */
	public static function switchStateFn(make:() -> FlxState):Void
	{
		previousState = getCurrentState();
		FlxG.switchState(make);
	}

	/* ───────────────────────────── Input Sugar ───────────────────────────────── */
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

	/* ───────────────────────────── Quick UI Helpers ──────────────────────────── */
	/**
	 * Create a simple colored background Spr, scaled to the game's virtual size.
	 * @param colorRGB [r,g,b] 0..255
	 * @param w base width (default 160)
	 * @param h base height (default 152)
	 */
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

	/**
	 * Camera flash convenience (works with state camera or default camera).
	 */
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

	/**
	 * Camera shake helper.
	 * @param intensity typical small value like 0.01 .. 0.02
	 * @param duration  seconds to shake
	 */
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
