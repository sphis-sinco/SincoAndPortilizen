package worldmap;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Worldmap extends FlxState
{
    var character:MapCharacter = new MapCharacter();

    var current_level:Int = 1;

    var mapGRP:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();

    override function create() {
        super.create();

        character.screenCenter();

        var i = 0;
        while(i < 3)
        {
            var level:FlxSprite = new FlxSprite(character.x + (i * 128), character.y);
            level.makeGraphic(24, 24, FlxColor.WHITE);
            mapGRP.add(level);

            i++;
        }

        add(mapGRP);
        add(character);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.anyJustReleased([LEFT, RIGHT]) && character.animation.name != 'run')
        {
            character.flipX = FlxG.keys.justReleased.LEFT;
            character.animation.play('run');
            FlxTimer.wait(1, () -> {
                character.animation.play('idle');
            });
        }
    }
}