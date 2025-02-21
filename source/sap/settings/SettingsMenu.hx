package sap.settings;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import sap.localization.LocalizationManager;

class SettingsMenu extends FlxState
{
	public static var saveValues:Map<String, Any> = ["language" => LocalizationManager.LANGUAGE];

	public static var settingsTexts:FlxTypedGroup<FlxText>;

	override function create()
	{
		settingsTexts = new FlxTypedGroup<FlxText>();
		add(settingsTexts);

                createSettingsText();

		super.create();
	}

	override function update(elapsed:Float)
	{
                if (FlxG.keys.justReleased.ANY) createSettingsText();

		super.update(elapsed);
	}

        public function createSettingsText()
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

                        settingsTexts.add(keyText);

                        i++;
                }
        }
}
