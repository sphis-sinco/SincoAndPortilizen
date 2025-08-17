package menus;

import flixel.util.FlxColor;

class LevelSelect extends FlxState
{
	override function create()
	{
                var background:Spr = new Spr();
                background.makeGraphic(160, 152, FlxColor.fromRGB(226, 226, 226));
                background.scaleSpr();
                background.screenCenter();
                add(background);

		super.create();
	}
}
