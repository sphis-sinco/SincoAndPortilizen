package stages.stage1;

class Stage1 extends FlxState
{
    var background:FlxSprite = new FlxSprite();

    var sinco:Sinco = new Sinco();

    override function create() {
        super.create();

        background.loadGraphic(FileManager.getImageFile('gameplay/sinco stages/Stage1BG'), true, 128, 128);

        background.animation.add('animation', [0, 1], 16);
        background.animation.play('animation');

		Global.scaleSprite(background, 1);
        background.screenCenter();
        add(background);

        sinco.screenCenter();
        sinco.y += sinco.height * 4;
        sinco.x -= sinco.width * 4;
        add(sinco);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }
    
}