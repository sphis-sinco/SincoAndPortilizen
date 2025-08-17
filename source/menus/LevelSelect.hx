package menus;

import sphis.Assets;
import flixel.group.FlxGroup.FlxTypedGroup;

class LevelSelect extends FlxState
{
        public var cursor:Spr;

        public var levelIcons:FlxTypedGroup<Spr>;
        public var levelNames:Array<String> = ['string-quest', 'osin', 'tres']; // tres is Sinco v Port

	override function create()
	{
                Global.changeDiscordRPCPresence('In the Level Select', null);

		add(Global.dummyBG([12, 12, 12]));

                levelIcons = new FlxTypedGroup<Spr>();
                add(levelIcons);

                cursor = new Spr(-3);
                cursor.loadGraphic(Assets.getImagePath('levelSelect/cursor'), true, 64, 64);
                cursor.animation.add('idle', [0], 24);
                cursor.animation.add('select', [1], 24);
                cursor.animation.play('idle');
                add(cursor);

                for (i in 0...levelNames.length) {
                        var levelIcon:Spr = new Spr(-3);
                        levelIcon.loadGraphic(Assets.getImagePath('levelSelect/level_icons/blank'));
                        
                        levelIcon.x = 64 + (i * (128 + 64));

                        levelIcon.screenCenter(Y);
                        levelIcon.y -= levelIcon.height * 1;

                        levelIcon.scaleSpr();

                        levelIcons.add(levelIcon);
                }

		super.create();
	}

        override function update(elapsed:Float) {
                super.update(elapsed);

                cursor.setPosition(FlxG.mouse.x, FlxG.mouse.y);
        }
}
