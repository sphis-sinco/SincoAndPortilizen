package sap.outdated;

class OutdatedMenu extends State
{
	public static var OUTDATED_TEXT:String = '-// ! You are running an outdated version ([VERSION]) ! \\\\-'
		+ '\n\nIt is recommended to update to the latest version (LATEST_VERSION)'
		+ '\nespecally if you are working on a mod with script files'
		+ '\nthrough the itch.io page or github depending on your platform';

	public static var BEGONE:Bool = false;

	override function create()
	{
		super.create();

		var textField:FlxText = new FlxText(0, 0, 0,
			OUTDATED_TEXT.replace('[VERSION]', '${Global.VERSION}').replace('LATEST_VERSION', '${OutdatedCheck.LATEST_VERSION}'), 16);
		textField.alignment = CENTER;
		textField.screenCenter();
		textField.applyMarkup(textField.text, [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED, true, true), '-')]);
		add(textField);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Global.keyJustReleased(ENTER))
		{
			BEGONE = true;
			InitState.proceed();
		}
	}
}
