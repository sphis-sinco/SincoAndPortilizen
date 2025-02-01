package title;

class TitleState extends FlxState
{
	var characterring:FlxSprite = new FlxSprite();

	override public function create()
	{
		characterring.loadGraphic(FileManager.getImageFile('titlescreen/CharacterRing'));
		characterring.scale.set(4, 4);
		characterring.screenCenter();
		add(characterring);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
