package;

import lime.app.Application;

class Global
{
	public static var APPCURMETA(get, never):Map<String, String>;

	static function get_APPCURMETA():Map<String, String>
	{
		return Application.current.meta;
	}

	public static var VERSION(get, never):String;

	static function get_VERSION():String
	{
		var version = APPCURMETA.get('version');

		return '${version}';
	}

	public static var DEBUG_BUILD(get, never):Bool;

	static function get_DEBUG_BUILD():Bool
	{
		return #if debug true #else false #end;
	}

	public static function pass() {}

	public static var DEFAULT_IMAGE_SCALE_MULTIPLIER:Int = 4;

	public static var SAVE_SLOT:Dynamic = 1;

	public static var SAVE_SLOT_PREFIX:String = 'SINCOandPORT-SLOT';

	public static function change_saveslot(slotsuffix:Dynamic = 1)
	{
		SAVE_SLOT = '$SAVE_SLOT_PREFIX-$slotsuffix';
		FlxG.save.bind(SAVE_SLOT, APPCURMETA.get('company'));

		GameplayStatus.setupGameplayStatus();

		trace('Switched save slot to "$SAVE_SLOT"');
	}

	public static function scaleSprite(sprite:FlxSprite, ?addition:Int = 0)
	{
		var returnsprite:FlxSprite = sprite;

		returnsprite.scale.set(DEFAULT_IMAGE_SCALE_MULTIPLIER + addition, DEFAULT_IMAGE_SCALE_MULTIPLIER + addition);

		return returnsprite;
	}

	public static function playMenuMusic() {
		if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					{
						FlxG.sound.playMusic(FileManager.getSoundFile('music/22'), 1.0, true);
					}
			} else {
				FlxG.sound.playMusic(FileManager.getSoundFile('music/22'), 1.0, true);
			}
	}

	public static function playSoundEffect(name:String) {
		FlxG.sound.play(FileManager.getSoundFile('sounds/$name'));
	}

	public static function hitHurt() {
		playSoundEffect('gameplay/hitHurt/hitHurt-${FlxG.random.int(0,4)}');
	}
}