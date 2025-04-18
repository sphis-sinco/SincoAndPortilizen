package sap.worldmap;

class CharIcon extends FlxSprite
{
	public var character:String = 'sinco';

	public function new(character:String)
	{
		super(0, 0);

		this.character = character;

		refresh();
	}

	public function refresh()
	{
		loadGraphic(FileManager.getImageFile('worldmap/character_select/icon-${this.character}'), true, 64, 64);

		animation.add('idle', [0], 0, false);
		animation.add('confirm', [0, 1, 2, 2, 3], 24, false);

		Global.scaleSprite(this);
	}
}
