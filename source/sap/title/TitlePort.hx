package sap.title;

class TitlePort extends FlxSprite
{
	override public function new()
	{
		super(0, 0);
		loadGraphic(FileManager.getImageFile('titlescreen/TitlePort'), true, 8, 8);
		animation.add('walk', [0, 1, 2, 3, 4], 12);
		animation.play('walk');
	}
}
