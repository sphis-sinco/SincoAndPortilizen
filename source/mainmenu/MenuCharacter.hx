package mainmenu;

class MenuCharacter extends FlxSprite
{

    override public function new(?X:Float = 0, ?Y:Float = 0, CHARSUFFIX:String = 'Sinco')
    {
        super(X,Y);
        loadGraphic(FileManager.getImageFile('mainmenu/MainMenu$CHARSUFFIX'), true, 80, 96);
        animation.add('visible', [0]);
        animation.add('blank', [1]);
        animation.play('visible');
        scale.set(Global.DEFAULT_IMAGE_SCALE_MULTIPLIER, Global.DEFAULT_IMAGE_SCALE_MULTIPLIER);
    }
}