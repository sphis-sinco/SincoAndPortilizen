package sap.mainmenu;

class PlayMenu extends MainMenu
{
	override public function new():Void
	{
		super('play');
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
		final worldmapSwitch:Void->Void = function()
		{
			FlxG.sound.music.stop();
			Global.switchState(new Worldmap());
		};

		switch (MainMenu.PUBLIC_CUR_SELECTION)
		{
			case 0:
				FlxG.save.data.gameplaystatus = GameplayStatus.returnDefaultGameplayStatus();

				worldmapSwitch();
			case 1:
				worldmapSwitch();

			case 2:
				FlxG.switchState(() -> new MainMenu());
		}
	}
}
