package stages.stage1;

class Stage1 extends FlxState
{
    var background:FlxSprite = new FlxSprite();

    override function create() {
        super.create();

        background.loadGraphic(FileManager.getImageFile('gameplay/sinco stages/Stage1BG'), true, 128, 128);

        background.animation.add('animation', [0, 1], 16);
        background.animation.play('animation');

        background.scale.set(Global.DEFAULT_IMAGE_SCALE_MULTIPLIER + 1, Global.DEFAULT_IMAGE_SCALE_MULTIPLIER + 1);
        background.screenCenter();
        add(background);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }
    
}