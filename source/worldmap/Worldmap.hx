package worldmap;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Worldmap extends FlxState
{
    var character:MapCharacter = new MapCharacter();

    var current_level:Int = 1;

    var mapGRP:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();

    override function create() {
        super.create();

        FlxG.camera.bgColor = 0xffffff;

        character.screenCenter();
        character.x = 32 + character.width;

        var i = 0;
        while(i < 3)
        {

            // TODO: change these to use MapTile once you figure out the bug

            var level:FlxSprite = new FlxSprite(character.getGraphicMidpoint().x - 12 + (i * 256), character.getGraphicMidpoint().y);
            level.makeGraphic(24, 24, FlxColor.RED);

            var level_transition:FlxSprite = new FlxSprite(level.x, level.y + (level.height / 4));
            level_transition.makeGraphic(256, Std.int(level.height / 2), 0xeeeeee);

            if (i + 1 < 3) mapGRP.add(level_transition);
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

            current_level += (character.flipX) ? -1 : 1;

            if (current_level < 1) {
                current_level += 1;
                return;
            }
            if (current_level > 3) {
                current_level -= 1;
                return;
            }
            
              character.animation.play('run');
                FlxTween.tween(character, {x: character.x + ((character.flipX) ? -256 : 256)}, 1, {
                onComplete: tween -> {
                    character.animation.play('idle');
                }
            });
        }
    }
}