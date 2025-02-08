package sap.stages.stage4;

class EnemyS4 extends FlxSprite
{
    override public function new() {
        super();

        loadGraphic(FileManager.getImageFile('gameplay/port stages/Stage4Enemy'), true, 32, 8);
        animation.add('run', [0,1,2,1], 4);
        animation.play('run');

        Global.scaleSprite(this, 2);
    }
}