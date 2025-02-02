package stages.stage1;

class Osin extends FlxSprite
{
    public function new()
    {
        super();
        
        loadGraphic(FileManager.getImageFile('gameplay/sinco stages/Stage1Osin'), true, 32, 32);
        animation.add('run', [0,1], 24);
        animation.add('hurt', [2], 0, false);
        animation.add('jump', [3], 0, false);
        animation.play('run');

        Global.scaleSprite(this, 0);
    }
    
}