package sap.settings;

import funkin.util.logging.AnsiTrace;
import funkin.util.logging.CrashHandler;
import sap.mainmenu.MainMenu;

class SettingsMenu extends FlxSubState
{
	public static var new_windowres:String;

	public static var saveValues:Map<String, Any> = [];
	public static var saveValues_array:Array<String> = [];
	public static var saveValue_length:Int = 0;

	public static var settingsTexts:FlxTypedGroup<FlxText>;

	public static var CURRENT_SELECTION:Int = 0;
	public static var SELECTED_SETTING:String = "";

	public static var overlay:BlankBG;

	override function create():Void
	{
		if (new_windowres == null)
		{
			if (SaveManager.getSettings().window_res != null)
			{
				new_windowres = SaveManager.getSettings().window_res;

				return;
			}

			trace('new_windowres is null + saved window_res is null');
			new_windowres = '${FlxG.width}x${FlxG.height}';
		}

		overlay = new BlankBG();
		overlay.color = 0x000000;
		overlay.alpha = 0.5;
		add(overlay);

		saveValuesUpdate();

		settingsTexts = new FlxTypedGroup<FlxText>();
		add(settingsTexts);

		createSettingsText();

		super.create();
	}

	public static function saveValuesUpdate():Void
	{
		saveValues_array = [];
		saveValue_length = 0;

		newSaveValue('language', Locale.localeName);
		newSaveValue('volume', FlxMath.roundDecimal(FlxG.sound.volume * 100, 0));

		#if desktop
		newSaveValue('window resolution', new_windowres);
		#end

		#if DISCORDRPC
		newSaveValue('discord rpc', FlxG.save.data.settings.discord_rpc);
		#end

		#if debug
		#if sys
		newSaveValue('download latest traces', null);
		#end
		#end

		newSaveValue('clear save', null);
	}

	public static function newSaveValue(name:String, value:Any):Void
	{
		saveValues.set(name, value);
		saveValues_array.push(name);
		saveValue_length++;
	}

	override function update(elapsed:Float):Void
	{
		if (Global.keyJustReleased(UP))
		{
			CURRENT_SELECTION--;
			if (CURRENT_SELECTION < 0)
			{
				CURRENT_SELECTION = 0;
			}
			createSettingsText();
		}

		if (Global.keyJustReleased(DOWN))
		{
			CURRENT_SELECTION++;
			if (CURRENT_SELECTION == saveValue_length)
			{
				CURRENT_SELECTION--;
			}
			createSettingsText();
		}

		if (Global.keyJustReleased(ENTER))
		{
			updateSettings();
		}

		if (Global.keyJustReleased(ESCAPE))
		{
			FlxG.save.data.settings.window_res = saveValues.get('window resolution');
			SaveManager.save();

			MainMenu.inSubstate = false;
			close();
		}

		super.update(elapsed);
	}

	public static function updateSettings():Void
	{
		switch (SELECTED_SETTING)
		{
			case 'language':
                                var newlang:String = Locale.localeName;

                                switch (newlang)
                                {
                                        case 'english': newlang = 'spanish';
                                        case 'spanish': newlang = 'portuguese';
                                        case 'portuguese': newlang = 'english';
                                }

				Locale.initalizeLocale(newlang);
				MainMenu.set_menuboxtexts(MainMenu.public_menutextsSelection);

				FileManager.writeToPath('cur_lang.txt', Locale.localeName);
			case 'volume':
				FlxG.sound.changeVolume(0.1);
				if (FlxG.sound.volume == 1)
				{
					FlxG.sound.changeVolume(-1);
				}
				FlxG.save.data.settings.volume = FlxG.sound.volume;
			case 'window resolution':
				window_res(saveValues.get(SELECTED_SETTING), true);
			#if DISCORDRPC
			case 'discord rpc':
				FlxG.save.data.settings.discord_rpc = !FlxG.save.data.settings.discord_rpc;
				if (FlxG.save.data.settings.discord_rpc)
				{
					Discord.DiscordClient.initialize();
				}
				else
				{
					Discord.DiscordClient.shutdown();
				}
			#end
			#if sys
			case 'download latest traces':
				final timestamp:String = funkin.util.DateUtil.generateTimestamp();
				trace('Downloading latest traces (${timestamp})');
				// funkin.util.FileUtil.createDirIfNotExists('trace_downloads');
				FileManager.writeToPath('trace_downloads/download-${timestamp}.log', AnsiTrace.neatTraceList());
			#end
			case 'clear save':
				SaveManager.clearSave();
				SaveManager.setupSave();
				SaveManager.save();
		}

		saveValuesUpdate();
		createSettingsText();
	}

	public static function window_res(res:String, change:Bool = false):Void
	{
		if (change)
		{
			switch (res)
			{
				case '1280x720':
					FlxG.resizeWindow(640, 608);
					new_windowres = '640x608';
				default:
					FlxG.resizeWindow(1280, 720);
					new_windowres = '1280x720';
			}
		}
		else
		{
			FlxG.resizeWindow(Std.parseInt(res.split('x')[0]), Std.parseInt(res.split('x')[1]));
		}
	}

	public static function createSettingsText():Void
	{
		TryCatch.tryCatch(() ->
		{
			for (i in 0...settingsTexts.members.length)
			{
				settingsTexts.members[i].kill();
				settingsTexts.remove(settingsTexts.members[0]);
			}
		});

		var i:Int = 0;
		var cur_y:Float = 10;
		for (key in saveValues_array)
		{
			var keystring:String = Global.getLocalizedPhrase('settings-$key', key);
			var keyvalue:Dynamic = saveValues.get(key);

			var keyText:FlxText = new FlxText(10, cur_y, 0, '$keystring${(keyvalue != null) ? ': $keyvalue' : ''}', 16);
			keyText.ID = i;
			keyText.color = (i == CURRENT_SELECTION) ? 0xFFFF00 : 0xFFFFFF;
			cur_y = cur_y + (i + 1 * keyText.size);

			if (i == CURRENT_SELECTION)
			{
				SELECTED_SETTING = key;
			}

			settingsTexts.add(keyText);

			i++;
		}
	}
}
