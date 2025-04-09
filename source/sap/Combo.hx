package sap;

class Combo extends FlxSprite
{

        override public function new() {
                super();

                loadGraphic(FileManager.getImageFile('gameplay/Combo'));
                Global.scaleSprite(this);
        }
        
}