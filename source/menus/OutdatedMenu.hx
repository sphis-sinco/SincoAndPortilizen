package menus;

import flixel.text.FlxText;

class OutdatedMenu extends State
{
	public static var OUTDATED_TEXT:String = '-// ! You are running an outdated version ([VERSION]) ! \\\\-'
		+ '\n\nIt is recommended to update to the latest version (LATEST_VERSION)'
		+ '\nthrough the itch.io page or github';

	public static var BEGONE:Bool = false;

	var portal:Spr;
	var git = new Spr();

	override function create()
	{
		super.create();

		git.loadGraphic(Assets.getImagePath('outdated/github'));
                git.scaleOffset = -3.5;
                git.scaleSpr();
		git.screenCenter();
		add(git);

		portal = new Spr(-2);
		portal.loadGraphic(Assets.getImagePath('outdated/portal'), true, 320, 256);
		portal.animation.add("anim", [0, 1, 2], 3, true);
		portal.animation.play("anim");
		portal.scaleSpr();
		portal.screenCenter();
		portal.y += 32;
		add(portal);

		var textField:FlxText = new FlxText(0, 10, 0,
			OUTDATED_TEXT.replace('[VERSION]', '${Global.VERSION}').replace('LATEST_VERSION', '${OutdatedCheck.LATEST_VERSION}'), 16);
		textField.alignment = 'center';
		textField.screenCenter(X);
		textField.applyMarkup(textField.text, [new FlxTextFormatMarkerPair(new FlxTextFormat(0xf32d2d, true, true), '-')]);
		textField.color = 0xe2e2e2;
		add(textField);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Global.keyJustReleased(ENTER) || FlxG.mouse.justReleased)
		{
			BEGONE = true;
			Global.switchState(new InitState());
		}
	}
}
