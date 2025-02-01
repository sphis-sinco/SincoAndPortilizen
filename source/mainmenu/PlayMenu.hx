package mainmenu;

class PlayMenu extends MainMenu
{

    override public function new() {
        super('play');
    }

    override function selectionCheck() {
        super.selectionCheck();

        switch (CUR_SELECTION)
			{
				case 2:
					FlxG.switchState(() -> new MainMenu());
			}
    }
}