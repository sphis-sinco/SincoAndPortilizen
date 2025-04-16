package sap.modding.menu;

import sap.mainmenu.MainMenu;

class ModsMenu extends FlxSubState
{
	#if sys
	public static var overlay:BlankBG;

	public static var modTexts:FlxTypedGroup<FlxText>;
        public static var modNames:Array<String> = [];

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

                modNames = [];

		var cur_y:Float = 10;
		var i:Int = 0;
		for (mod in ModFolderManager.MODS)
		{
			var text:FlxText = new FlxText(20, cur_y, 0, '${ModFolderManager.modInfo(FileManager.getJSON('${ModFolderManager.MODS_FOLDER}${mod}/meta.json'))}', Std.int(32 * 0.5));
			text.alignment = LEFT;
			text.ID = i;

			i++;

			modTexts.add(text);
                        modNames.push(mod);

			cur_y += 25;
			totalSpacing += 25;
		}
		updateText();
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (Global.keyJustReleased(ESCAPE))
		{
			MainMenu.inSubstate = false;
			FlxG.save.data.enabled_mods = ModFolderManager.ENABLED_MODS;
                        SaveManager.save();
                        // FlxG.resetGame();
			close();
		}

		if (Global.anyKeysPressed([UP, DOWN]) && Global.keyPressed(SHIFT))
		{
			scroll((Global.keyPressed(UP)) ? SCROLL_AMOUNT : -SCROLL_AMOUNT);
		}
		else if (Global.anyKeysPressed([UP, DOWN, ENTER]))
		{
			if (Global.keyJustReleased(ENTER))
			{
				ModFolderManager.toggleMod(ModFolderManager.MODS[CURRENT_SELECTION]);
				updateText();
				return;
			}

			CURRENT_SELECTION += (Global.keyJustReleased(DOWN)) ? 1 : -1;
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

	public static function scroll(Amount:Float):Void
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

	public static function updateText():Void
	{
		for (text in modTexts)
		{
			text.color = (text.ID == CURRENT_SELECTION) ? FlxColor.YELLOW : FlxColor.WHITE;
			text.alpha = (ModFolderManager.ENABLED_MODS.contains(modNames[text.ID])) ? 1.0 : 0.5;
		}
	}
	#end
}
