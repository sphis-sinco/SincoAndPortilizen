package;

class Global
{
	/**
	 * Basically `Application.current.meta.get('version')` shortcut
	 */
	public static var VERSION(get, never):String;

	/**
	 * Returns `Application.current.meta.get('version')` basically
	 * @return String
	 */
	static function get_VERSION():String
	{
		var version:String = Application.VERSION;

		trace('Version: ${version}');
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

		trace(FlxG.save.data);
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

		final tracelog:String = 'Trying to play music track: ${file[file.length - 1]} ${musicinfo} ${originator}';

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
			{
				trace(tracelog);
				FlxG.sound.playMusic(FileManager.getSoundFile('music/$filename'), volume, loop);
			}
		}
		else
		{
			trace(tracelog);
			FlxG.sound.playMusic(FileManager.getSoundFile('music/$filename'), volume, loop);
		}
	}

	/**
	 * Plays a sound effect using the `name` param
	 * @param name this is the filename/filepath, for example `blipSelect` would return `assets/sounds/blipSelect.wav`
	 */
	public static function playSoundEffect(name:String, ?posinfo:PosInfos):Void
	{
		final file:Array<String> = name.split('/');
		trace('Trying to play sound effect: ${file[file.length - 1]} | ${posInfoString(posinfo)}');

		FlxG.sound.play(FileManager.getSoundFile('sounds/$name'));
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
		#if html5 return; #end

		if (!FlxG.save.data.gameplaystatus.levels_complete.contains(lvl))
		{
			trace('New level complete: ${lvl} | ${posInfoString(posinfo)}');
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
}
