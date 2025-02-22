package sap.mainmenu;

import sap.cutscenes.intro.IntroCutscene;
import sap.stages.Continue;

class PlayMenu extends MainMenu
{
	override public function new()
	{
		super('play');
	}

	override function selectionCheck()
	{
		super.selectionCheck();

		if (menutextsSelection == 'play')
		{
			playSelectionCheck();
		}
	}

	public static dynamic function playSelectionCheck()
	{
		switch (MainMenu.PUBLIC_CUR_SELECTION)
		{
			case 0:
				FlxG.sound.music.stop();
				FlxG.switchState(() -> new IntroCutscene());

			case 1:
				FlxG.sound.music.stop();
				FlxG.switchState(() -> new Continue());

			case 2:
				FlxG.switchState(() -> new MainMenu());
		}
	}
}
