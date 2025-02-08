package stages.stage4;

class Tile extends FlxSprite
{

    override public function new() {
        super();

        loadGraphic(FileManager.getImageFile('gameplay/port stages/Stage4Tileset'), true, 8, 8);
        animation.add('wall', [0]);
        animation.play('wall');

        Global.scaleSprite(this);
    }
    
}