package sap.medals;

import sap.mainmenu.MainMenu;

class MedalsMenu extends FlxSubState
{
	public static var overlay:BlankBG;

	public static var medalTexts:FlxTypedGroup<FlxText>;
	public static var totalSpacing:Int = 0;

        public static var MEDALS_JSON:Dynamic;

	override function create():Void
	{
		super.create();

		overlay = new BlankBG();
		overlay.color = 0x000000;
		overlay.alpha = 0.5;
		add(overlay);

                MEDALS_JSON = FileManager.getJSON(FileManager.getDataFile('medals.json'));

		medalTexts = new FlxTypedGroup<FlxText>();
		add(medalTexts);

		var cur_y:Float = 10;
		var i:Int = 0;
		for (medal in FileSystem.readDirectory('assets/images/medals/awards'))
		{
			if (medal == 'award.png')
				return;

                        if (!Reflect.hasField(MEDALS_JSON, medal.split('.')[0]))
                        {
                                return;
                        }

			var text:FlxText = new FlxText(0, cur_y, 0, Reflect.getProperty(MEDALS_JSON, medal.split('.')[0]), Std.int(32 * 0.5));
			text.alignment = CENTER;
			text.screenCenter(X);
			text.ID = i;
			i++;

			medalTexts.add(text);

			cur_y += 50;
			totalSpacing += 50;
		}
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
