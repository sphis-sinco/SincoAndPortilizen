package menus;

import flixel.util.FlxCollision;
import flixel.input.FlxSwipe;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;

class Credits extends State
{
	public var credits:Array<String>;

	public var creditsText:FlxTypedGroup<FlxText>;
	public var totalSpacing:Int = 0;

	public var directional_up:Spr;
	public var directional_down:Spr;

	override function create():Void
	{
		creditsInit();
		super.create();

		creditsText = new FlxTypedGroup<FlxText>();
		add(creditsText);

		directional_up = new Spr(0);
		directional_down = new Spr(0);

		directional_up.scaleSpr();
		directional_down.scaleSpr();

		directional_up.loadGraphic(Assets.getImagePath('mobile/directional'));
		directional_down.loadGraphic(Assets.getImagePath('mobile/directional'));
		directional_down.flipY = true;

		directional_up.screenCenter();
		directional_down.screenCenter();

		directional_up.x = directional_up.width;
		directional_down.x = FlxG.width - (directional_down.width * 2);

		#if MOBILE_BUILD
		add(directional_up);
		add(directional_down);
		add(new backend.mobile.BackButton(new TitleScreen()));
		#end

		var cur_y:Float = 10;
		var i:Int = 0;
		for (credit in credits)
		{
			var text:FlxText = new FlxText(0, cur_y, FlxG.width, credit, #if MOBILE_BUILD 32 #else 24 #end);
			text.alignment = CENTER;
			text.screenCenter(X);
			text.color = FlxColor.fromRGB(226, 226, 226);
			text.ID = i;
			i++;

			creditsText.add(text);

			cur_y += Std.int(text.height) + text.size + 8;
			totalSpacing += Std.int(text.height) + text.size + 8;
		}
	}

	override function update(elapsed:Float):Void
	{
		Global.playMenuMusic();
		super.update(elapsed);

		if (Global.keyJustReleased(ESCAPE))
		{
			Global.switchState(new TitleScreen());
		}

		if (Global.anyKeysPressed([UP, DOWN]))
		{
			scroll((Global.keyPressed(UP)) ? SCROLL_AMOUNT : -SCROLL_AMOUNT);
		}

		/*
			for (swipe in FlxG.swipes)
			{
				if (swipe.degrees > 0 && swipe.degrees < 181)
					scroll(SCROLL_AMOUNT + swipe.distance);
				if (swipe.degrees > 180 && swipe.degrees < 361)
					scroll(-SCROLL_AMOUNT + swipe.distance);
			}
		 */

		for (button in [directional_up, directional_down])
		{
			button.scaleSpr();

			if (FlxG.mouse.overlaps(button))
			{
				button.scale.set(button.scale.x - .1, button.scale.y - .1);

				if (FlxG.mouse.pressed && button.visible)
					scroll((button == directional_up) ? SCROLL_AMOUNT : -SCROLL_AMOUNT);
			}

			directional_up.screenCenter();
			directional_down.screenCenter();

			directional_up.x = 32;
			directional_down.x = FlxG.width - directional_down.width - 32;
		}
	}

	public var SCROLL_AMOUNT:Float = 10.0;

	public function scroll(Amount:Float):Void
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

	public function creditsInit():Void
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
