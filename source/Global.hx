package;

import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;

class Global
{
	public static var previousState:String;

	public static var GENERATED_BY(get, set):String;

	static function get_GENERATED_BY():String
		return 'Sinco and Portilizen v${VERSION}';

	static function set_GENERATED_BY(value:String):String
		return value;

	public static var VERSION(get, never):String;

	public static dynamic function get_VERSION():String
		return '0.2b';

	public static var DEFAULT_IMAGE_SCALE_MULTIPLIER:Int = 4;

	public static var SAVE_SLOT:Dynamic = 1;
	public static var SAVE_SLOT_PREFIX:String = 'SAP';

	public static function change_saveslot(slotsuffix:Dynamic = 1):Void
	{
		SAVE_SLOT = '$SAVE_SLOT_PREFIX-$slotsuffix';
		FlxG.save.bind(SAVE_SLOT, 'SAPTeam');

		var mergeSave:FlxSave = new FlxSave();
		mergeSave.bind('SINCOandPORT-SLOT-$slotsuffix', 'SAPTeam');

		trace('Switched save slot to "$SAVE_SLOT"');

		if (mergeSave.data != null)
		{
			try
			{
				FlxG.save.data.volume ??= mergeSave.data.settings.volume;
				FlxG.save.data.discord_rpc ??= mergeSave.data.settings.discord_rpc;
				FlxG.save.data.levels_complete ??= mergeSave.data.gameplaystatus.levels_complete;
				FlxG.save.data.medals ??= mergeSave.data.medals;
			}
			catch (e) {}
		}

		FlxG.save.data.volume ??= 100;
		FlxG.save.data.discord_rpc ??= true;
		FlxG.save.data.levels_complete ??= [];
		FlxG.save.data.medals ??= [];

		trace('Save dump: ${FlxG.save.data}');
	}

	public static function scaleSprite(sprite:FlxSprite, ?addition:Float = 0):FlxSprite
	{
		var returnsprite:FlxSprite = sprite;

		returnsprite.scale.set(DEFAULT_IMAGE_SCALE_MULTIPLIER + addition, DEFAULT_IMAGE_SCALE_MULTIPLIER + addition);
		returnsprite.updateHitbox();

		return returnsprite;
	}

	public static function playMenuMusic():Void
		playMusic('Lado');

	public static function playMusic(filename:String):Void
	{
		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing) {}
		}
		else {}
	}

	public static function playSoundEffect(name:String):Void
		FlxG.sound.play('');

	public static function hitHurt():Void
		playSoundEffect('gameplay/hitHurt/hitHurt-${FlxG.random.int(1, 4)}');

	public static function beatLevel(lvl:Int = 1):Void
		if (!FlxG.save.data.gameplaystatus.levels_complete.contains(lvl))
			FlxG.save.data.gameplaystatus.levels_complete.push(lvl);

	public static function changeDiscordRPCPresence(details:String = null, state:Null<String>):Void
	{
		#if !DISCORDRPC
		return;
		#else
		trace('Discord presence is being changed (details: ${details}, state: ${state}) | ${posInfoString(posinfo)}');
		DiscordClient.changePresence(details, state);
		#end
	}

	public static function getCurrentState():String
		return Type.getClassName(Type.getClass(FlxG.state)).split(".").pop();

	public static function switchState(new_state:FlxState):Void
	{
		previousState = getCurrentState();
		FlxG.switchState(() -> new_state);
	}

	public static function anyKeysPressed(keys:Array<FlxKey>):Bool
		return FlxG.keys.anyPressed(keys);

	public static function keyPressed(key:FlxKey):Bool
		return anyKeysPressed([key]);

	public static function anyKeysJustReleased(keys:Array<FlxKey>):Bool
		return FlxG.keys.anyJustReleased(keys);

	public static function keyJustReleased(key:FlxKey):Bool
		return anyKeysJustReleased([key]);

	public static function anyKeysJustPressed(keys:Array<FlxKey>):Bool
		return FlxG.keys.anyJustPressed(keys);

	public static function keyJustPressed(key:FlxKey):Bool
		return anyKeysJustPressed([key]);

	public static function dummyBG(colorRGB:Array<Int>):Spr
	{
		var background:Spr = new Spr();
		background.makeGraphic(160, 152, FlxColor.fromRGB(colorRGB[0], colorRGB[1], colorRGB[2]));
		background.scaleSpr();
		background.screenCenter();
		return background;
	}
}
