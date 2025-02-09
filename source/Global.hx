package;

import sinlib.utilities.Application;

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
		var version = Application.VERSION;

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
		return #if debug true #else false #end;
	}

	/**
	 * Dummy function
	 */
	public static function pass() {}

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
	public static function change_saveslot(slotsuffix:Dynamic = 1)
	{
		SAVE_SLOT = '$SAVE_SLOT_PREFIX-$slotsuffix';
		FlxG.save.bind(SAVE_SLOT, Application.COMPANY);

		GameplayStatus.setupGameplayStatus();

		trace('Switched save slot to "$SAVE_SLOT"');
	}

	/**
	 * Automatically scales a sprite using `DEFAULT_IMAGE_SCALE_MULTIPLIER`
	 * @param sprite the sprite thats being scaled
	 * @param addition additional offset
	 */
	public static function scaleSprite(sprite:FlxSprite, ?addition:Int = 0)
	{
		var returnsprite:FlxSprite = sprite;

		returnsprite.scale.set(DEFAULT_IMAGE_SCALE_MULTIPLIER + addition, DEFAULT_IMAGE_SCALE_MULTIPLIER + addition);

		return returnsprite;
	}

	/**
	 * Plays the main music for menus (22) if its null, and if there is no music playing
	 */
	public static function playMenuMusic()
	{
		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
			{
				FlxG.sound.playMusic(FileManager.getSoundFile('music/22'), 1.0, true);
			}
		}
		else
		{
			FlxG.sound.playMusic(FileManager.getSoundFile('music/22'), 1.0, true);
		}
	}

	/**
	 * Plays a sound effect using the `name` param
	 * @param name this is the filename/filepath, for example `blipSelect` would return `assets/sounds/blipSelect.wav`
	 */
	public static function playSoundEffect(name:String)
	{
		FlxG.sound.play(FileManager.getSoundFile('sounds/$name'));
	}

	/**
	 * Plays a random hitHurt sound effect
	 */
	public static function hitHurt()
	{
		playSoundEffect('gameplay/hitHurt/hitHurt-${FlxG.random.int(0, 4)}');
	}

	/**
	 * If the current emerald count is `emerald` - 1 then the current emerald count gets set to `emerald`
	 * @param emerald what you are trying to set the current emerald count to
	 */
	public static function setEmeraldAmount(emerald:Int = 1)
	{
		if (FlxG.save.data.gameplaystatus.chaos_emeralds == emerald - 1)
			FlxG.save.data.gameplaystatus.chaos_emeralds = emerald;
	}

	/**
	 * If the current level is lower than `lvl` by 1 then the current level gets set to `lvl`
	 * @param lvl what you are trying to set the current level to
	 */
	public static function setLevel(lvl:Int = 1)
	{
		if (FlxG.save.data.gameplaystatus.level == lvl - 1)
			FlxG.save.data.gameplaystatus.level = lvl;
	}
}
