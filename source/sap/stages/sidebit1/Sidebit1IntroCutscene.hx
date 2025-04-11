package sap.stages.sidebit1;

import sap.title.TitleState;

class Sidebit1IntroCutscene extends State
{
        public static var sprite:SparrowSprite;

        override public function new() {
              super();
              
              sprite = new SparrowSprite('cutscenes/sidebit1/pre-sidebit1');
              sprite.addAnimationByPrefix('part1', 'animation piece 1', 24, false);
              sprite.addAnimationByPrefix('part2', 'animation piece 2', 24, false);
              sprite.addAnimationByPrefix('part3', 'animation piece 3', 24, false);
              sprite.addAnimationByPrefix('part4', 'animation piece 4', 24, false);
        }

        override function create() {
                super.create();

                add(sprite);
                sprite.screenCenter();
                sprite.playAnimation('part1');
                sprite.animation.onFinish.add(animName -> {
                        switch(sprite.animation.name)
                        {
                                case 'part1': sprite.playAnimation('part2');
                                case 'part2': sprite.playAnimation('part3');
                                case 'part3': sprite.playAnimation('part4');
                                case 'part4': FlxG.switchState(TitleState.new);
                        }
                });
        }
}