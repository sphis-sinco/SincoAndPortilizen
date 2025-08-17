package menus;

import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;

class LevelSelect extends FlxState
{
	public var cursor:Spr;

	public var levelIcons:FlxTypedGroup<Spr>;
	public var levelNames:Array<String> = ['string-quest', 'osin', 'tres']; // tres is Sinco v Port
	public var selectedLevel:Int = 0;

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

		for (i in 0...levelNames.length)
		{
			var levelIcon:Spr = new Spr(-3.25);
			levelIcon.loadGraphic(Assets.getImagePath('levelSelect/level_icons/blank'));

			levelIcon.x = (64 + 32) + (i * (128 + 64));

			levelIcon.screenCenter(Y);
			levelIcon.y -= levelIcon.height * 1;

			levelIcon.scaleSpr();

			levelIcon.ID = i;
			levelIcons.add(levelIcon);
		}

                message.size = 32;
                message.screenCenter();
                message.alignment = 'center';
                add(message);

                super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.mouse.visible)
			FlxG.mouse.visible = false;

		cursor.setPosition(FlxG.mouse.x - (cursor.width / 2), FlxG.mouse.y - (cursor.height / 2));
		cursor.animation.play('idle');

		selectedLevel = -1;
		for (icon in levelIcons.members)
		{
			icon.scaleSpr();
			if (cursor.overlaps(icon))
			{
				selectedLevel = icon.ID;
				icon.scale.set(icon.scale.x - .1, icon.scale.y - .1);
				cursor.animation.play('select');
			}
		}

		FlxG.watch.addQuick('selectedLevel', selectedLevel);

                if (selectedLevel > -1)
                {
                        var data:Dynamic;

                        try {
                                data = Assets.getFileJsonContent('levels/${levelNames[selectedLevel]}');
                        } catch(e) {
                                data = null;
                        }

                        if (data == null)
                        {
                                message.text = 'Missing level file:\n\n"${levelNames[selectedLevel]}"';
                                message.alpha = 1;
                                message.screenCenter();
                                FlxTween.cancelTweensOf(message);
                                FlxTween.tween(message, {alpha: 0}, 1, { startDelay: 1 });
                        }
                }
	}

        public var message:FlxText = new FlxText();
}
