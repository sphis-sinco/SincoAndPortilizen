package sap.stages.stage4;

class PortS4 extends AdvancedSprite
{
	override public function new()
	{
		super();

		loadGraphic(FileManager.getImageFile('gameplay/port stages/Stage4Port-Redone'), true, 8, 8);
		animation.add('run', [0, 1], 4);
		animation.add('jump', [2], 4, false);

		animation.play('run');

		Global.scaleSprite(this, 2);
	}
}
