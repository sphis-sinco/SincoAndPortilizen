package sap.mainmenu;

import sap.cutscenes.intro.IntroCutscene;
import sap.worldmap.Worldmap;

class PlayMenu extends MainMenu
{
	override public function new():Void
	{
		super('play');

                // disable sticker transition
                this.stickerDegen = false;
	}

	override function selectionCheck():Void
	{
		super.selectionCheck();

		if (menutextsSelection == 'play')
		{
			playSelectionCheck();
		}
	}

	public static function playSelectionCheck():Void
	{
		switch (MainMenu.PUBLIC_CUR_SELECTION)
		{
			case 0:
				FlxG.save.data.gameplaystatus = GameplayStatus.returnDefaultGameplayStatus();

				FlxG.sound.music.stop();
				Global.switchState(new IntroCutscene());

			case 1:
				FlxG.sound.music.stop();
				Global.switchState(new Worldmap());

			case 2:
				FlxG.switchState(() -> new MainMenu());
		}
	}
}
