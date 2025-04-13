package sap.modding.menu;

import sap.mainmenu.MainMenu;

class ModsMenu extends FlxSubState
{
	#if sys
	public static var overlay:BlankBG;

	public static var modTexts:FlxTypedGroup<FlxText>;
	public static var totalSpacing:Int = 0;

	public static var CURRENT_SELECTION:Int = 0;

	override function create():Void
	{
		super.create();

		overlay = new BlankBG();
		overlay.color = 0x000000;
		overlay.alpha = 0.5;
		add(overlay);

		modTexts = new FlxTypedGroup<FlxText>();
		add(modTexts);

		var cur_y:Float = 10;
		var i:Int = 0;
		for (mod in ModFolderManager.MODS)
		{
			var dir_meta:ModMetaData = FileManager.getJSON('${ModFolderManager.MODS_FOLDER}${mod}/meta.json');

			var text:FlxText = new FlxText(20, cur_y, 0, dir_meta.name, Std.int(32 * 0.5));
			text.alignment = LEFT;
			text.ID = i;

			i++;

			modTexts.add(text);

			cur_y += 25;
			totalSpacing += 25;
		}
		updateText();
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.ESCAPE)
		{
			MainMenu.inSubstate = false;
			close();
		}

		if (FlxG.keys.anyPressed([UP, DOWN]) && FlxG.keys.pressed.SHIFT)
		{
			scroll((FlxG.keys.pressed.UP) ? SCROLL_AMOUNT : -SCROLL_AMOUNT);
		}
		else if (FlxG.keys.anyJustReleased([UP, DOWN]))
		{
			CURRENT_SELECTION += (FlxG.keys.justReleased.DOWN) ? 1 : -1;
			if (CURRENT_SELECTION < 0)
			{
				trace('Prevent underflow');
				CURRENT_SELECTION = 0;
			}
			if (CURRENT_SELECTION > modTexts.members.length - 1)
			{
				trace('Prevent overflow');
				CURRENT_SELECTION = modTexts.members.length - 1;
			}
			updateText();
		}
	}

	public static var SCROLL_AMOUNT:Float = 10.0;

	public dynamic function scroll(Amount:Float):Void
	{
		for (text in modTexts)
		{
			text.y += Amount;

			if ((text.y < -totalSpacing / 2 || text.y > totalSpacing / 2) && text.ID == 0)
			{
				text.y -= Amount;
				return;
			}
		}
	}

	public static dynamic function updateText():Void
	{
		for (text in modTexts)
		{
			text.color = (text.ID == CURRENT_SELECTION) ? FlxColor.YELLOW : FlxColor.WHITE;

			for (mod in ModFolderManager.MODS)
			{
				var dir_meta:ModMetaData = FileManager.getJSON('${ModFolderManager.MODS_FOLDER}${mod}/meta.json');

				if (text.text == dir_meta.name)
				{
					text.alpha = (ModFolderManager.ENABLED_MODS.contains(mod)) ? 1.0 : 0.5;
				}
			}
		}
	}
	#end
}
