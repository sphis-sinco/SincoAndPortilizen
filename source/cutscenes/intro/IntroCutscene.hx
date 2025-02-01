package cutscenes.intro;

class IntroCutscene extends FlxState
{
	var panel:FlxSprite = new FlxSprite();

	override function create()
	{
		panel.screenCenter();
		add(panel);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}