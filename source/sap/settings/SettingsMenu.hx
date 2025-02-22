package sap.settings;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import sap.localization.LocalizationManager;
import sap.mainmenu.MainMenu;

class SettingsMenu extends FlxSubState
{
	public static var SECTION:String = "this_is_a_section";

	public static var saveValues:Map<String, Any> = [];
	public static var saveValue_length:Int = 0;
	public static var settingsTexts:FlxTypedGroup<FlxText>;

        public static var CURRENT_SELECTION:Int = 0;
        public static var SELECTED_SETTING:String = "";
	
        public static var overlay:BlankBG;

	override function create()
	{
                
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

        public static function saveValuesUpdate() {
                saveValues.set('GENERAL', SECTION);

                saveValues.set('language', LocalizationManager.LANGUAGE);
                saveValues.set('volume', FlxG.sound.volume * 100);

                saveValues.set('VIDEO SETTINGS', SECTION);

                saveValue_length = 2;
        }
        

	override function update(elapsed:Float)
	{
                if (FlxG.keys.justReleased.UP) {
                        CURRENT_SELECTION--;
                        if (CURRENT_SELECTION < 0) CURRENT_SELECTION = 0;
                        createSettingsText();
                }

                if (FlxG.keys.justReleased.DOWN) {
                        CURRENT_SELECTION++;
                        if (CURRENT_SELECTION == saveValue_length) CURRENT_SELECTION--;
                        createSettingsText();
                }

                if (FlxG.keys.justReleased.ENTER) {
                        updateSettings();
                }

                if (FlxG.keys.justReleased.ESCAPE) {
			MainMenu.inSubstate = false;
			close();
                }

		super.update(elapsed);
	}

        public static dynamic function updateSettings() {
                switch (SELECTED_SETTING)
                {
                        case 'language':
                                LocalizationManager.swapLanguage();
                                MainMenu.set_menuboxtexts(MainMenu.public_menutextsSelection);
                        case 'volume':
                                FlxG.sound.changeVolume(0.1);
                                if (FlxG.sound.volume == 1)
                                        FlxG.sound.changeVolume(-1);
                }

                saveValuesUpdate();
                createSettingsText();
        }
        

        public static function createSettingsText()
        {
                TryCatch.tryCatch(() -> {
                        for (i in 0...settingsTexts.members.length) {
                                settingsTexts.members[i].kill();
                                settingsTexts.remove(settingsTexts.members[0]);
                        }
                });

                var i:Int = 0;
                for (key in saveValues.keys())
                {
                        var keystring:String = Global.getLocalizedPhrase('settings-$key', key);
                        var keyvalue:Dynamic = saveValues.get(key);

                        var keyText:FlxText = new FlxText(10, 10, 0, '$keystring: $keyvalue', 16);
                        if (keyvalue == SECTION)
                                keyText.size = keyText.size * 2;
                        
                        keyText.ID = i;
                        keyText.color = (i == CURRENT_SELECTION) ? 0xFFFF00 : 0xFFFFFF;
                        keyText.y += i * keyText.size;

                        if (i == CURRENT_SELECTION) SELECTED_SETTING = key;

                        settingsTexts.add(keyText);

                        i++;
                }
        }
}
