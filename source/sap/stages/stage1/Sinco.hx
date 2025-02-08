package stages.stage1;

class Sinco extends FlxSprite
{

    public function new()
    {
        super();
        
        loadGraphic(FileManager.getImageFile('gameplay/sinco stages/Stage1Sinco'), true, 32, 32);
        animation.add('run', [0,1,2,3], 24);
        animation.add('jump', [4], 0, false);
        animation.add('ded', [5], 0, false);
        animation.play('run');

        Global.scaleSprite(this, 0);
    }
    
}