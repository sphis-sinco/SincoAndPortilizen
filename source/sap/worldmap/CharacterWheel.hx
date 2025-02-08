package worldmap;

class CharacterWheel extends FlxSprite
{
	override public function new()
	{
		super();

		loadGraphic(FileManager.getImageFile('worldmap/CharWheel'), true, 32, 32);

		animation.add('port', [0], 0, false);
		animation.add('sinco', [2], 0, false);
		animation.add('port-sinco', [0, 1, 2], 12, false);
		animation.add('sinco-port', [2, 3, 0], 12, false);
		animation.add('justspin', [0, 1, 2, 3], 12, true);
        
        animation.play('justspin');

		Global.scaleSprite(this);
	}
}
