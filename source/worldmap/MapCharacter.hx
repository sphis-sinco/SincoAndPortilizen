package worldmap;

class MapCharacter extends FlxSprite
{

    override public function new() {
        super();

        swapCharacter();
        animation.play('idle');
    }

    public var char:String = 'Sinco';

    public function swapCharacter() {
        loadGraphic(FileManager.getImageFile(
            'worldmap/${char}WorldMap'
        ), true, 16, 16);
        animation.add('idle', [0]);
        animation.add('jump', [1]);
        animation.add('wait', [2]);
        animation.add('run', [3, 4], 12);
        Global.scaleSprite(this);
    }
    
}