package sap.credits;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import sap.mainmenu.MainMenu;

class CreditsSubState extends FlxSubState
{
	public static var overlay:BlankBG;

	public static var creditsJSON:Array<CreditsEntry>;

	public static var creditsText:FlxTypedGroup<FlxText>;
	public static var totalSpacing:Int = 0;

	override function create()
	{
		super.create();

                overlay = new BlankBG();
		overlay.color = 0x000000;
		overlay.alpha = 0.5;
		add(overlay);

                creditsText = new FlxTypedGroup<FlxText>();
		add(creditsText);

		var cur_y:Float = 10;
                var i:Int = 0;
		for (credit in creditsJSON)
		{
			var text:FlxText = new FlxText(0, cur_y, 0, credit.text, Std.int(32 * credit.size));
			text.screenCenter(X);
			text.color = FlxColor.fromRGB(credit.color[0], credit.color[1], credit.color[2], (credit.color[3] != null) ? credit.color[3] : 255);
                        text.ID = i;
                        i++;

			creditsText.add(text);

			cur_y += credit.spacing;
			totalSpacing += credit.spacing ;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.ESCAPE)
		{
			MainMenu.inCredits = false;
			close();
		}

		if (FlxG.keys.anyPressed([UP, DOWN]))
		{
			scroll((FlxG.keys.pressed.UP) ? SCROLL_AMOUNT : -SCROLL_AMOUNT);
		}
	}

        public static var SCROLL_AMOUNT:Float = 10.0;

	public dynamic function scroll(Amount:Float)
	{
		for (text in creditsText)
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
