package sap.settings;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import openfl.filters.BitmapFilter;
import sap.localization.LocalizationManager;
import sap.mainmenu.MainMenu;
import sap.shaders.GrayscaleShader;

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

	override function create()
	{
		new_windowres = '${FlxG.width}x${FlxG.height}';

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

	public static function saveValuesUpdate()
	{
		saveValues_array = [];
		saveValue_length = 0;

		newSaveValue('language', LocalizationManager.LANGUAGE);
		newSaveValue('volume', FlxMath.roundDecimal(FlxG.sound.volume * 100, 0));

		#if desktop
		newSaveValue('window resolution', new_windowres);
		#end

		newSaveValue('grayscale filter', Global.ENABLED_SHADERS.contains('grayscale'));
	}

	public static function newSaveValue(name:String, value:Any)
	{
		saveValues.set(name, value);
		saveValues_array.push(name);
		saveValue_length++;
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justReleased.UP)
		{
			CURRENT_SELECTION--;
			if (CURRENT_SELECTION < 0)
				CURRENT_SELECTION = 0;
			createSettingsText();
		}

		if (FlxG.keys.justReleased.DOWN)
		{
			CURRENT_SELECTION++;
			if (CURRENT_SELECTION == saveValue_length)
				CURRENT_SELECTION--;
			createSettingsText();
		}

		if (FlxG.keys.justReleased.ENTER)
		{
			updateSettings();
		}

		if (FlxG.keys.justReleased.ESCAPE)
		{
			MainMenu.inSubstate = false;
			close();
		}

		super.update(elapsed);
	}

	public static dynamic function updateSettings()
	{
		switch (SELECTED_SETTING)
		{
			case 'language':
				LocalizationManager.swapLanguage();
				MainMenu.set_menuboxtexts(MainMenu.public_menutextsSelection);

				FileManager.writeToPath('cur_lang.txt', LocalizationManager.LANGUAGE);
			case 'volume':
				FlxG.sound.changeVolume(0.1);
				if (FlxG.sound.volume == 1)
					FlxG.sound.changeVolume(-1);
			case 'window resolution':
				window_res();
			case 'grayscale filter':
				toggleShader('grayscale', new GrayscaleShader());
		}

		saveValuesUpdate();
		createSettingsText();
	}

	public static function toggleShader(shader:String, shader_class:BitmapFilter)
	{
		if (Global.ENABLED_SHADERS.contains(shader))
		{
			Global.remove_shader(shader);
		}
		else
		{
			Global.add_shader(shader_class, shader);
		}
	}

	static function window_res()
	{
		var res:String = saveValues.get(SELECTED_SETTING);
		switch (res)
		{
			case '1280x1216':
				FlxG.resizeWindow(320, 304);
				new_windowres = '320x304';
			case '320x304':
				FlxG.resizeWindow(160, 152);
				new_windowres = '160x152';
			case '160x152':
				FlxG.resizeWindow(640, 608);
				new_windowres = '640x608';
			default:
				FlxG.resizeWindow(1280, 1216);
				new_windowres = '1280x1216';
		}
	}

	public static function createSettingsText()
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

			var keyText:FlxText = new FlxText(10, cur_y, 0, '$keystring: $keyvalue', 16);
			keyText.ID = i;
			keyText.color = (i == CURRENT_SELECTION) ? 0xFFFF00 : 0xFFFFFF;
			cur_y = cur_y + (i + 1 * keyText.size);

			if (i == CURRENT_SELECTION)
				SELECTED_SETTING = key;

			settingsTexts.add(keyText);

			i++;
		}
	}
}
