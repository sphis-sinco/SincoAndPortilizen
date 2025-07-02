package sap.medals;

import sap.mainmenu.MainMenu;

class MedalsMenu extends FlxSubState
{
	#if sys
	public static var overlay:BlankBG;
	public static var overlayWhite:BlankBG;

	public static var medalTexts:FlxTypedGroup<FlxText>;
	public static var medalIcons:FlxTypedGroup<FlxSprite>;
	public static var totalSpacing:Int = 0;

	public static var MEDALS_JSON:Dynamic;

	override function create():Void
	{
		super.create();

		overlay = new BlankBG();
		overlay.color = 0x000000;
		overlay.alpha = 0.5;
		add(overlay);

		overlayWhite = new BlankBG();
		overlayWhite.color = 0xFFFFFF;
		overlayWhite.alpha = 0.5;
		overlayWhite.scale.x = 0.75;
		overlayWhite.screenCenter(X);
		add(overlayWhite);

		MEDALS_JSON = FileManager.getJSON(FileManager.getDataFile('medals.json'));

		medalTexts = new FlxTypedGroup<FlxText>();
		add(medalTexts);

		medalIcons = new FlxTypedGroup<FlxSprite>();
		add(medalIcons);

		var cur_y:Float = 10;
		var i:Int = 0;
                #if EXCESS_TRACES
                trace(MedalData.unlocked_medals);
                #end
		for (medal in FileManager.readDirectory('assets/images/medals/awards', ['.png']))
		{
			if (medal != 'award.png')
			{
				#if EXCESS_TRACES
				trace(medal.split('.')[0]);
				#end

				if (Reflect.hasField(MEDALS_JSON, medal.split('.')[0]))
				{
					var text:FlxText = new FlxText(0, cur_y, 0, Reflect.getProperty(MEDALS_JSON, medal.split('.')[0]), Std.int(32 * 0.5));
					text.alignment = CENTER;
					text.screenCenter(X);
					text.ID = i;

					var iconShader:HSVShader = new HSVShader();
					iconShader.saturation = 1.0;

					var iconPath:String = Medal.getMedalPath(medal.split('.')[0]);

					var icon:FlxSprite = new FlxSprite();
					icon.loadGraphic(iconPath);
					Global.scaleSprite(icon, -2);
					icon.setPosition(text.x - 32, text.y);
					icon.ID = i;

					i++;

					if (!MedalData.unlocked_medals.contains(medal.split('.')[0]))
					{
						var finalString:String = '';
						var hiddenChar:String = '*';

						var ii:Int = 0;
						for (letter in text.text)
						{
							if (!text.text.isSpace(ii))
								finalString += hiddenChar;

							ii++;
						}

						text.text = finalString;
						iconShader.saturation = 0.2;
						iconShader.value = 0.1;
					}
					icon.shader = iconShader;

					medalTexts.add(text);
					medalIcons.add(icon);

					cur_y += 50;
					totalSpacing += 50;
				}
			}
		}
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
		for (text in medalTexts)
		{
			text.y += Amount;

			if ((text.y < -totalSpacing / 2 || text.y > totalSpacing / 2) && text.ID == 0)
			{
				text.y -= Amount;
				return;
			}
		}

		for (icon in medalIcons)
		{
			icon.y += Amount;

			if ((icon.y < -totalSpacing / 2 || icon.y > totalSpacing / 2) && icon.ID == 0)
			{
				icon.y -= Amount;
				return;
			}
		}
	}
	#end
}
