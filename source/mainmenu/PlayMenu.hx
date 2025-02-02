package mainmenu;

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
					Global.pass();

				case 1:
					Global.pass();

				case 2:
					FlxG.switchState(() -> new MainMenu());
			}
		}
	}
}
