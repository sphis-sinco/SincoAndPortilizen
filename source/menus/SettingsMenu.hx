package menus;

import flixel.util.FlxCollision;
import flixel.text.FlxText;

class SettingsMenu extends State
{
	public var coloredLevelSelect:Spr;
	public var discordRPC:Spr;

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

		pageCont.push(coloredLevelSelect);

		discordRPC = new Spr();
		discordRPC.loadGraphic(Assets.getImagePath('settings/DiscordRPC'), true, 64, 64);
		discordRPC.animation.add('false', [0]);
		discordRPC.animation.add('true', [1]);
		discordRPC.scaleSpr();
		discordRPC.setPosition(coloredLevelSelect.x + coloredLevelSelect.width + 32, coloredLevelSelect.y);
		discordRPC.ID = 1;

		discordRPC.color = 0x5e5ea0;
		#if !DISCORDRPC
		discordRPC.color = 0x4e4e4e;
		#else
		pageCont.push(coloredLevelSelect);
		#end

		add(discordRPC);

		descriptionText = new FlxText(0, 0, FlxG.width, 'Monkeyballs', 16);
		descriptionText.alignment = 'center';
		add(descriptionText);

		cursor = new Spr(-3);
		cursor.loadGraphic(Assets.getImagePath('levelSelect/cursor'), true, 64, 64);
		cursor.animation.add('idle', [0], 24);
		cursor.animation.add('select', [1], 24);
		cursor.animation.play('idle');
		add(cursor);

		if (FlxG.random.bool())
		{
			cursor.color = 0x4eb10c;
			Global.changeDiscordRPCPresence('Powering their options', 'Settings Menu'); // electricity = power. Shut up
		}
		else
		{
			cursor.color = 0x4e0c6f;
			Global.changeDiscordRPCPresence('Sabotaging their options', 'Settings Menu');
		}
	}

	public var pageCont:Array<Spr> = [];

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		cursor.setPosition(FlxG.mouse.x - (cursor.width / 2), FlxG.mouse.y - (cursor.height / 2));
		cursor.animation.play('idle');

		coloredLevelSelect.animation.play(Std.string(FlxG.save.data.colored_levelSelect));
		discordRPC.animation.play(Std.string(FlxG.save.data.discord_rpc));

		if (Global.keyJustReleased(ESCAPE))
			Global.switchState(new LevelSelect());

		descriptionText.text = '';
		for (setting in pageCont)
		{
			setting.scaleSpr();
			if (FlxCollision.pixelPerfectCheck(cursor, setting))
			{
				cursor.animation.play('select');

				if (selected != setting.ID)
					selected = setting.ID;

				if (selected == setting.ID)
				{
					switch (setting.ID)
					{
						case 0:
							descriptionText.text = 'Colored Level Select (${(FlxG.save.data.colored_levelSelect) ? 'enabled' : 'disabled'}) - Enables Color on the Level Select';
						case 1:
							descriptionText.text = 'Discord RPC (${(FlxG.save.data.discord_rpc) ? 'enabled' : 'disabled'}) - Enables Rich Presence on Discord';
					}
				}

				setting.scale.set(setting.scale.x - .1, setting.scale.y - .1);

				if (FlxG.mouse.justReleased)
				{
					Global.playSoundEffect('blipSelect');

					switch (setting.ID)
					{
						case 0:
							FlxG.save.data.colored_levelSelect = !FlxG.save.data.colored_levelSelect;
						case 1:
							FlxG.save.data.discord_rpc = !FlxG.save.data.discord_rpc;

							if (FlxG.save.data.discord_rpc)
							{
								Discord.DiscordClient.initialize();
								Global.changeDiscordRPCPresence('Re-enabled', 'Settings Menu');
							}
							else
								Discord.DiscordClient.shutdown();
					}

					FlxG.save.flush();
				}
			}

			if (cursor.animation.name != 'select')
				selected = -1;
		}
	}
}
