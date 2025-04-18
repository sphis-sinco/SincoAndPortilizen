package sap.credits;

import sap.mainmenu.MainMenu;

class CreditsSubState extends FlxSubState
{
	public static var overlay:BlankBG;

	public static var creditsJSON:Array<CreditsEntry>;

	public static var creditsText:FlxTypedGroup<FlxText>;
	public static var totalSpacing:Int = 0;

	override function create():Void
	{
		creditsJSONInit();
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
			text.alignment = CENTER;
			text.screenCenter(X);
			text.color = FlxColor.fromRGB(credit.color[0], credit.color[1], credit.color[2], (credit.color[3] != null) ? credit.color[3] : 255);
			text.ID = i;
			i++;

			creditsText.add(text);

			cur_y += credit.spacing;
			totalSpacing += credit.spacing;
		}

		add(MedalData.unlockMedal('Huh, someone cares'));
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (Global.keyJustReleased(ESCAPE))
		{
			MainMenu.inSubstate = false;
			close();
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

	public static function creditsJSONInit():Void
	{
		TryCatch.tryCatch(() ->
		{
			creditsJSON = FileManager.getJSON(FileManager.getDataFile('credits.json'));
		}, {
				errFunc: () ->
				{
					trace('Error while loading credits JSON');
					creditsJSON = [
						{
							"text": "Credits could not load",
							"size": 10,
							"color": [255, 255, 255],
							"spacing": 500
						}
					];
				}
		});
		#if EXCESS_TRACES
		trace('Loaded credits JSON');
		#end
	}
}
