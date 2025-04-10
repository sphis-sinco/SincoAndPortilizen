package sap.stages;

import flxgif.FlxGifSprite;

class PaulPortGameOver extends State
{
        public static var thegif:FlxGifSprite;

        override function create() {
                super.create();

                thegif = new FlxGifSprite();
                thegif.loadGif(FileManager.getImageFile('gameplay/port stages/portgameover').replace('png', 'gif'));
                thegif.screenCenter();
                thegif.antialiasing = true;
                add(thegif);
        }

        override function update(elapsed:Float) {
                super.update(elapsed);
        }
        
}