package sap.worldmap;

class CharIcon extends FlxSprite
{
	public function new(character:String)
        {
                super(0,0);
                loadGraphic(FileManager.getImageFile('worldmap/character_select/icon-${character}'), true, 64, 64);
               
                animation.add('idle', [0], 0, false);
                animation.add('confirm', [1,2,2,3], 24, false);
        }
}
