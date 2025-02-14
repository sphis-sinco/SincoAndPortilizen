package sap.title;

class TitlePort extends AdvancedSprite
{
	override public function new()
	{
		super();
                
		loadGraphic(FileManager.getImageFile('titlescreen/TitlePort'), true, 8, 8);
		animation.add('walk', [0, 1, 2, 3, 4], 12);
		animation.play('walk');
	}
}
