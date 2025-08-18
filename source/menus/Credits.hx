package menus;

import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;

class CreditsSubState extends State
{
	public static var overlay:Spr;

	public static var credits:Array<String>;

	public static var creditsText:FlxTypedGroup<FlxText>;
	public static var totalSpacing:Int = 0;

	override function create():Void
	{
		super.create();

		overlay = Global.dummyBG([12,12,12]);
		overlay.alpha = 0.5;
		add(overlay);

		creditsText = new FlxTypedGroup<FlxText>();
		add(creditsText);

		var cur_y:Float = 10;
		var i:Int = 0;
		for (credit in credits)
		{
			var text:FlxText = new FlxText(0, cur_y, 0, credit, 32);
			text.alignment = CENTER;
			text.screenCenter(X);
			text.color = FlxColor.fromRGB(12,12,12);
			text.ID = i;
			i++;

			creditsText.add(text);

			cur_y += 32;
			totalSpacing += 32;
		}
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (Global.keyJustReleased(ESCAPE))
		{
                        Global.switchState(new LevelSelect());
		}

		if (Global.anyKeysPressed([UP, DOWN]))
		{
			scroll((Global.keyPressed(UP)) ? SCROLL_AMOUNT : -SCROLL_AMOUNT);
		}
	}

	public static var SCROLL_AMOUNT:Float = 10.0;

	public static function scroll(Amount:Float):Void
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

	public static function creditsInit():Void
	{
		try
		{
			credits = Assets.getFileTextContent('credits.txt').split('\n');
		}
		catch (e)
		{
			credits = ['$e'];
		}
        }
}
