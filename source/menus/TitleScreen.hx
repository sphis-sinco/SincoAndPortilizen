package menus;

import flixel.tweens.FlxTween;
import flixel.util.FlxCollision;
import flixel.text.FlxText;

class TitleScreen extends State
{
	public var logo:Spr;
	public var logoSuffixes:Array<String> = ['', '-dj', '-paul'];

	public var levelSelect:Spr;
	public var settings:Spr;
	public var creditsButton:Spr;

	public var cursor:Spr;

	override function create()
	{
		super.create();

		logo = new Spr(#if !MOBILE_BUILD - 3 #else - 2 #end);
		logo.loadGraphic(Assets.getImagePath('title/logo${logoSuffixes[FlxG.random.int(0, logoSuffixes.length - 1)]}'));
		logo.scaleSpr();
		logo.screenCenter();
		logo.y -= logo.height / 4;
		add(logo);

		cursor = new Spr(-3);
		cursor.loadGraphic(Assets.getImagePath('levelSelect/cursor'), true, 64, 64);
		cursor.animation.add('idle', [0], 24);
		cursor.animation.add('select', [1], 24);
		cursor.animation.play('idle');

		creditsButton = new Spr(#if !MOBILE_BUILD - 3 #else 0 #end);
		creditsButton.loadGraphic(Assets.getImagePath('levelSelect/credits'));
		creditsButton.scaleSpr();
		creditsButton.setPosition(FlxG.width - creditsButton.width - 32, FlxG.height - creditsButton.height - 32);
		add(creditsButton);

		levelSelect = new Spr(#if !MOBILE_BUILD - 2 #else 0 #end);
		levelSelect.loadGraphic(Assets.getImagePath('title/levelSelect'));
		levelSelect.scaleSpr();
		levelSelect.screenCenter();
		levelSelect.x -= (levelSelect.width / 2);
		levelSelect.y += (logo.height / 4);
		add(levelSelect);

		settings = new Spr(#if !MOBILE_BUILD - 2 #else 0 #end);
		settings.loadGraphic(Assets.getImagePath('title/settings'));
		settings.scaleSpr();
		settings.screenCenter();
		settings.x += (settings.width / 2);
		settings.y += (logo.height / 4);
		add(settings);

		Global.changeDiscordRPCPresence('', 'Title Screen');

		add(new FlxText(3, FlxG.height - #if !MOBILE_BUILD 32 #else 64 #end, FlxG.width, 'v${Global.VERSION} (b${Global.BUILD})', #if !MOBILE_BUILD 16 #else 32 #end));
		add(cursor);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		Global.playMenuMusic();

		cursor.setPosition(FlxG.mouse.x - (cursor.width / 2), FlxG.mouse.y - (cursor.height / 2));
		cursor.animation.play('idle');

		cursor.visible = true;
		for (button in [levelSelect, settings, creditsButton])
		{
			button.scaleSpr();

			if (FlxCollision.pixelPerfectCheck(cursor, button))
			{
				cursor.animation.play('select');

				button.scale.set(button.scale.x - .1, button.scale.y - .1);

				if (FlxG.mouse.justReleased)
				{
					Global.playSoundEffect('blipSelect');

					if (button == levelSelect)
						Global.switchState(new LevelSelect());
					if (button == settings)
						Global.switchState(new SettingsMenu());

					if (button == creditsButton)
						Global.switchState(new Credits());
				}
			}
		}

		#if MOBILE_BUILD
		cursor.visible = false;
		#end
	}
}
