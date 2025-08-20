package menus;

import flixel.tweens.FlxTween;
import flixel.util.FlxCollision;
import flixel.text.FlxText;

class TitleScreen extends State
{
	public var logo:Spr;

	public var cursor:Spr;

	override function create()
	{
		super.create();

		logo = new Spr(-3);
		logo.loadGraphic(Assets.getImagePath('title/logo'));
		logo.scaleSpr();
		logo.screenCenter();
		add(logo);

		cursor = new Spr(-3);
		cursor.loadGraphic(Assets.getImagePath('levelSelect/cursor'), true, 64, 64);
		cursor.animation.add('idle', [0], 24);
		cursor.animation.add('select', [1], 24);
		cursor.animation.play('idle');
		add(cursor);

		Global.changeDiscordRPCPresence('', 'Title Screen');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		Global.playMenuMusic();

		cursor.setPosition(FlxG.mouse.x - (cursor.width / 2), FlxG.mouse.y - (cursor.height / 2));
		cursor.animation.play('idle');

		for (button in [logo])
		{
			button.scaleSpr();

			if (FlxCollision.pixelPerfectCheck(cursor, button))
			{
				cursor.animation.play('select');

				button.scale.set(button.scale.x - .1, button.scale.y - .1);

				if (FlxG.mouse.justReleased)
				{
					var ps = true;
					if (ps)
						Global.playSoundEffect('blipSelect');
				}
			}
		}
	}
}
