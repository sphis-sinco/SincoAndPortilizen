package sap;

class BlankBG extends FlxSprite
{
	override public function new():Void
	{
		super();

		loadGraphic(FileManager.getImageFile('blankBG'));
	}
}
