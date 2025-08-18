package menus;

import flixel.text.FlxText;

class SettingsMenu extends State
{
	public var coloredLevelSelect:Spr;

	public var cursor:Spr;
	public var selected:Int = -1;

	public var descriptionText:FlxText;

	override function create()
	{
		super.create();

		coloredLevelSelect = new Spr();
		coloredLevelSelect.loadGraphic(Assets.getImagePath('settings/ColoredLevelSelect'), true, 64, 64);
		coloredLevelSelect.animation.add('false', [0]);
		coloredLevelSelect.animation.add('true', [1]);
		coloredLevelSelect.scaleSpr();
		coloredLevelSelect.setPosition(32, 32);
		coloredLevelSelect.ID = 0;
		add(coloredLevelSelect);

		descriptionText = new FlxText(0, 0, FlxG.width, 'Monkeyballs', 16);
		descriptionText.alignment = 'center';
		add(descriptionText);

		cursor = new Spr(-3);
		cursor.loadGraphic(Assets.getImagePath('levelSelect/cursor'), true, 64, 64);
		cursor.animation.add('idle', [0], 24);
		cursor.animation.add('select', [1], 24);
		cursor.animation.play('idle');
		add(cursor);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		cursor.setPosition(FlxG.mouse.x - (cursor.width / 2), FlxG.mouse.y - (cursor.height / 2));
		cursor.animation.play('idle');

		coloredLevelSelect.animation.play(Std.string(FlxG.save.data.colored_levelSelect));

		if (Global.keyJustReleased(ESCAPE))
			Global.switchState(new LevelSelect());

		descriptionText.text = '';
		for (setting in [coloredLevelSelect])
		{
			setting.scaleSpr();
			if (cursor.overlaps(setting))
			{
				cursor.animation.play('select');

				if (selected != setting.ID)
				{
					Global.playSoundEffect('blipSelect');
					selected = setting.ID;
				}

				if (selected == setting.ID)
				{
					switch (setting)
					{
						case coloredLevelSelect:
							descriptionText.text = 'Colored Level Select (${(FlxG.save.data.colored_levelSelect) ? 'enabled' : 'disabled'}) - Enables Color on the Level Select';
					}
				}

				setting.scale.set(setting.scale.x - .1, setting.scale.y - .1);

				if (FlxG.mouse.justReleased)
				{
					switch (setting)
					{
						case coloredLevelSelect:
							FlxG.save.data.colored_levelSelect = !FlxG.save.data.colored_levelSelect;
					}
				}
			}

			if (cursor.animation.name != 'select')
				selected = -1;
		}
	}
}
