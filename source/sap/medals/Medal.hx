package source.sap.medals;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class Medal extends FlxTypedSpriteGroup<FlxSprite>
{
        var medalBox:MedalBox;
        
        var medalIcon:FlxSprite;

        override public function new(medal:String = 'award') {
                super();

                medalBox = new MedalBox();
                add(medalBox);

                medalIcon = new FlxSprite().loadGraphic(FileManager.getImageFile('medals/awards/${medal}'));
                add(medalIcon);
        }
        
}