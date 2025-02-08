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
			switch (CUR_SELECTION)
			{
				case 0:
                    FlxG.save.data.gameplaystatus = GameplayStatus.returnDefaultGameplayStatus();

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
}
