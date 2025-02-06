package stages.stage4;

class PortS4 extends FlxSprite
{

    override public function new() {
        super();

        loadGraphic(FileManager.getImageFile('gameplay/port stages/Stage4Port'), true, 32, 32);
        animation.add('run', [0,2,5,2], 2);

        animation.play('run');

        Global.scaleSprite(this);
    }
    
}