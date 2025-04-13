package sap.medals;

import sap.mainmenu.MainMenu;

class MedalsMenu extends FlxSubState
{
	public static var overlay:BlankBG;

	public static var medalTexts:FlxTypedGroup<FlxText>;
	public static var totalSpacing:Int = 0;

	override function create():Void
	{
		super.create();

		overlay = new BlankBG();
		overlay.color = 0x000000;
		overlay.alpha = 0.5;
		add(overlay);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.ESCAPE)
		{
			MainMenu.inSubstate = false;
			close();
		}

		if (FlxG.keys.anyPressed([UP, DOWN]))
		{
			scroll((FlxG.keys.pressed.UP) ? SCROLL_AMOUNT : -SCROLL_AMOUNT);
		}
	}

	public static var SCROLL_AMOUNT:Float = 10.0;

	public dynamic function scroll(Amount:Float):Void
	{
		for (text in medalTexts)
		{
			text.y += Amount;

			if ((text.y < -totalSpacing / 2 || text.y > totalSpacing / 2) && text.ID == 0)
			{
				text.y -= Amount;
				return;
			}
		}
	}
}
