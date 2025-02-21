package sap.settings;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import sap.localization.LocalizationManager;

class SettingsMenu extends FlxState
{
	public static var saveValues:Map<String, Any> = [];

	public static var settingsTexts:FlxTypedGroup<FlxText>;

        public static var CURRENT_SELECTION:Int = 0;
        public static var SELECTED_SETTING:String = "";

	override function create()
	{
                saveValuesUpdate();
                
		settingsTexts = new FlxTypedGroup<FlxText>();
		add(settingsTexts);

                createSettingsText();

		super.create();
	}

        public static function saveValuesUpdate() {
                saveValues.set('language', LocalizationManager.LANGUAGE);
        }
        

	override function update(elapsed:Float)
	{
                if (FlxG.keys.justReleased.LEFT) {
                        CURRENT_SELECTION--;
                        if (CURRENT_SELECTION < 0) CURRENT_SELECTION = 0;
                        createSettingsText();
                }

                if (FlxG.keys.justReleased.RIGHT) {
                        CURRENT_SELECTION++;
                        if (CURRENT_SELECTION >= settingsTexts.members.length - 1) CURRENT_SELECTION = settingsTexts.members.length - 1;
                        createSettingsText();
                }

                if (FlxG.keys.justReleased.ENTER) {
                        updateSettings();
                }

		super.update(elapsed);
	}

        public static dynamic function updateSettings() {
                switch (SELECTED_SETTING)
                {
                        case 'language':
                                LocalizationManager.swapLanguage();
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

                        var keyText:FlxText = new FlxText(0, 10, 0, '$keystring: $keyvalue', 16);
                        keyText.screenCenter(X);
                        keyText.ID = i;
                        keyText.color = (i == CURRENT_SELECTION) ? 0xFFFF00 : 0xFFFFFF;

                        if (i == CURRENT_SELECTION) SELECTED_SETTING = key;

                        settingsTexts.add(keyText);

                        i++;
                }
        }
}
