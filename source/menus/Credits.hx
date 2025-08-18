package menus;

import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;

class Credits extends State
{
	public static var credits:Array<String>;

	public static var creditsText:FlxTypedGroup<FlxText>;
	public static var totalSpacing:Int = 0;

	override function create():Void
	{
                creditsInit();
		super.create();

		creditsText = new FlxTypedGroup<FlxText>();
		add(creditsText);

		var cur_y:Float = 10;
		var i:Int = 0;
		for (credit in credits)
		{
			var text:FlxText = new FlxText(0, cur_y, FlxG.width, credit, 24);
			text.alignment = CENTER;
			text.screenCenter(X);
			text.color = FlxColor.fromRGB(226,226,226);
			text.ID = i;
			i++;

			creditsText.add(text);

			cur_y += Std.int(text.height) + text.size + 8;
			totalSpacing += Std.int(text.height) + text.size + 8;
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
