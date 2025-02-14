package sap;

class BlankBG extends FlxSprite
{

        override public function new() {
                super();

                loadGraphic(FileManager.getImageFile('blankBG'));
        }
        
}