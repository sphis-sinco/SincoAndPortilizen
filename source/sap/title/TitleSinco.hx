package sap.title;

class TitleSinco extends FlxSprite
{
	override public function new()
	{
		super(0, 0);
		loadGraphic(FileManager.getImageFile('titlescreen/TitleSinco'), true, 8, 8);
		animation.add('walk', [0, 1, 2, 3], 12);
		animation.play('walk');
	}
}
