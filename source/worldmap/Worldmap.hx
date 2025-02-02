package worldmap;

import flixel.util.FlxTimer;

class Worldmap extends FlxState
{
    var character:MapCharacter = new MapCharacter();

    var current_level:Int = 1;

    override function create() {
        super.create();

        character.screenCenter();
        add(character);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.anyJustReleased([LEFT, RIGHT]))
        {
            character.flipX = FlxG.keys.justReleased.LEFT;
            character.animation.play('run');
            FlxTimer.wait(1, () -> {
                character.animation.play('idle');
            });
        }
    }
}