package;

import funkin.ui.transition.StickerSubState;

class Global
{
        public static var RANDOM_STICKER_FOLDERS:Array<String> = ['sinco', 'misc'];
	public static var RANDOM_STICKER_PACKS:Map<String,String> = [
		'sinco' -> ['all', 'set-1', 'set-2'],
		'misc' -> ['all']
	];

        public static function randomStickerFolder():String
        {
                return Global.RANDOM_STICKER_FOLDERS[FlxG.random.int(0, Global.RANDOM_STICKER_FOLDERS.length - 1)];
        }

	public static var GENERATED_BY(get, set):String;

	static function get_GENERATED_BY():String
	{
		return 'Sinco and Portilizen v${VERSION_FULL}';
	}

	static function set_GENERATED_BY(value:String):String
	{
		return value;
	}

	public static var VERSION(get, never):String;

	public static var VERSION_FULL(get, never):String;

	static function get_VERSION():String
	{
		return Application.VERSION;
	}

	static function get_VERSION_FULL():String
	{
		var version:String = Application.VERSION;

		if (SLGame.isDebug)
			version += '-debug';
		#if PLAYTESTER_BUILD version += '-playtest'; #end

		#if EXCESS_TRACES trace('Version: ${version}'); #end

		return '${version}';
	}

	/**
	 * This says if its a debug build
	 */
	public static var DEBUG_BUILD(get, never):Bool;

	/**
	 * Returns `true` if debug, `false` if not.
	 * @return Bool
	 */
	static function get_DEBUG_BUILD():Bool
	{
		return SLGame.isDebug;
	}

	/**
	 * Dummy function
	 */
	public static function pass():Void {}

	/**
	 * The default image scale multiplier for the pixel art sprites
	 */
	public static var DEFAULT_IMAGE_SCALE_MULTIPLIER:Int = 4;

	/**
	 * The suffix for the save slot
	 */
	public static var SAVE_SLOT:Dynamic = 1;

	/**
	 * The prefix for the save slot
	 */
	public static var SAVE_SLOT_PREFIX:String = 'SINCOandPORT-SLOT';

	/**
	 * This switches the save slot using `SAVE_SLOT_PREFIX` and `slotsuffix`
	 * @param slotsuffix this is the save slot suffix, for example if you do `1` it will be `SAVE_SLOT_PREFIX`-1
	 */
	public static function change_saveslot(slotsuffix:Dynamic = 1):Void
	{
		SAVE_SLOT = '$SAVE_SLOT_PREFIX-$slotsuffix';
		FlxG.save.bind(SAVE_SLOT, Application.COMPANY);

		SaveManager.setupSave();
		trace('Switched save slot to "$SAVE_SLOT"');

		trace('Save dump: ${FlxG.save.data}');
		FlxG.save.flush();
	}

	/**
	 * Automatically scales a sprite using `DEFAULT_IMAGE_SCALE_MULTIPLIER`
	 * @param sprite the sprite thats being scaled
	 * @param addition additional offset
	 */
	public static function scaleSprite(sprite:FlxSprite, ?addition:Int = 0):FlxSprite
	{
		var returnsprite:FlxSprite = sprite;

		returnsprite.scale.set(DEFAULT_IMAGE_SCALE_MULTIPLIER + addition, DEFAULT_IMAGE_SCALE_MULTIPLIER + addition);

		return returnsprite;
	}

	/**
	 * Plays the main music for menus (22) if its null, and if there is no music playing
	 */
	public static function playMenuMusic(?posinfo:PosInfos):Void
	{
		playMusic('22', posinfo);
	}

	/**
	 * Turns PosInfo data into a string readable for debugging purposes
	 * @param posinfo 
	 * @return String
	 */
	public static function posInfoString(?posinfo:PosInfos):String
	{
		return '${posinfo.fileName}/${posinfo.methodName}():${posinfo.lineNumber}';
	}

	/**
	 * Plays music
	 */
	public static function playMusic(filename:String, ?volume:Float = 1.0, ?loop:Bool = false, ?posinfo:PosInfos):Void
	{
		final file:Array<String> = filename.split('/');

		final musicinfo:String = '(volume: ${volume * 100}, ${(loop) ? 'looping' : 'not looping'})';
		final originator:String = '| ${posInfoString(posinfo)}';

		final tracelog:String = 'Trying to play music track: "${file[file.length - 1]}" ${musicinfo} ${originator}';

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
			{
				#if EXCESS_TRACES trace(tracelog); #end
				FlxG.sound.playMusic(FileManager.getSoundFile('music/$filename'), volume, loop);
			}
		}
		else
		{
			#if EXCESS_TRACES trace(tracelog); #end
			FlxG.sound.playMusic(FileManager.getSoundFile('music/$filename'), volume, loop);
		}
	}

	/**
	 * Plays a sound effect using the `name` param
	 * @param name this is the filename/filepath, for example `blipSelect` would return `assets/sounds/blipSelect.wav`
	 */
	public static function playSoundEffect(name:String, ?PATH_TYPE:sinlib.utilities.FileManager.PathTypes, ?posinfo:PosInfos):Void
	{
		#if EXCESS_TRACES
		final file:Array<String> = name.split('/');
		trace('Trying to play sound effect: "${file[file.length - 1]}" | ${posInfoString(posinfo)}');
		#end

		FlxG.sound.play(FileManager.getSoundFile('sounds/$name', PATH_TYPE));
	}

	/**
	 * Plays a random hitHurt sound effect
	 */
	public static function hitHurt(?posinfo:PosInfos):Void
	{
		playSoundEffect('gameplay/hitHurt/hitHurt-${FlxG.random.int(1, 4)}', posinfo);
	}

	/**
	 * If the current level is lower than `lvl` by 1 then the current level gets set to `lvl`
	 * @param lvl what you are trying to set the current level to
	 */
	public static function beatLevel(lvl:Int = 1, ?posinfo:PosInfos):Void
	{
		final newLvlTrace:String = 'New level complete: ${lvl} | ${posInfoString(posinfo)}';

		#if html5
		if (!WebSave.LEVELS_COMPLETE.contains(lvl))
		{
			trace(newLvlTrace);
			WebSave.LEVELS_COMPLETE.push(lvl);
		}

		return;
		#end

		if (!FlxG.save.data.gameplaystatus.levels_complete.contains(lvl))
		{
			trace(newLvlTrace);
			FlxG.save.data.gameplaystatus.levels_complete.push(lvl);
		}
	}

	/**
	 * Changes the discord rpc presence details and state
	 * @param details The first row of text
	 * @param state The second row of text
	 */
	public static function changeDiscordRPCPresence(details:String, state:Null<String>, ?posinfo:PosInfos):Void
	{
		#if !DISCORDRPC
		return;
		#else
		trace('Discord presence is being changed (details: ${details}, state: ${state}) | ${posInfoString(posinfo)}');
		DiscordClient.changePresence(details, state);
		#end
	}

	/**
	 * Returns the current state
	 * @return String
	 */
	public static function getCurrentState():String
	{
		return Type.getClassName(Type.getClass(FlxG.state)).split(".").pop();
	}

	/**
	 * Returns a key value from `LocalizationManager.TEXT_CONTENT`
	 * @param phrase the key you are trying to read
	 * @return String
	 */
	public static function getLocalizedPhrase(phrase:String, ?fallback:String):String
	{
		var phrase_that_works:String = phrase.toLowerCase().replace(' ', '-');

		var returnPhrase:String = LocalizationManager.TEXT_CONTENT.get(phrase_that_works);
		if (returnPhrase == null)
		{
			returnPhrase = (fallback == null) ? phrase_that_works : fallback;
		}

		return returnPhrase;
	}

	public static function callScriptFunction(func:String, ?arguments:Array<Dynamic>):Void
	{
		ScriptManager.callScript(func, arguments);
	}

	public static function setScriptVariable(name:String, value:Dynamic, allowOverride:Bool = true):Void
	{
		ScriptManager.setScript(name, value, allowOverride);
	}

	public static function switchState(new_state:FlxState, ?oldStickers:Bool = false, ?stickerSet:String = 'sinco'. ?stickerPack:String = 'all'):Void
	{
		var oldStickars:Array<funkin.ui.transition.StickerSubState.StickerSprite> = [];

		TryCatch.tryCatch(function()
		{
			for (sticker in StickerSubState.grpStickers.members)
			{
				oldStickars.push(sticker);
			}
		});

		var stickerTransition = new funkin.ui.transition.StickerSubState({
			targetState: state -> new_state,
			stickerSet: stickerSet,
			stickerPack: stickerPack,
			oldStickers: (oldStickars.length > 0 && oldStickers) ? oldStickars : null
		});

		FlxG.state.openSubState(stickerTransition);
	}
}
