package menus;

import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.util.FlxCollision;
import flixel.text.FlxText;

class SettingsMenu extends State
{
	public var coloredLevelSelect:Spr;
	public var discordRPC:Spr;
	public var volume:Spr;
	public var clearSave:Spr;

	public static var clearSavePos:FlxPoint;

	public static var cursorSkin:Int;

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
		#end
		pageCont.push(discordRPC);
		add(discordRPC);

		volume = new Spr();
		volume.loadGraphic(Assets.getImagePath('settings/Volume'), true, 64, 64);
		volume.animation.add('100', [10]);
		volume.animation.add('90', [9]);
		volume.animation.add('80', [8]);
		volume.animation.add('70', [7]);
		volume.animation.add('60', [6]);
		volume.animation.add('50', [5]);
		volume.animation.add('40', [4]);
		volume.animation.add('30', [3]);
		volume.animation.add('20', [2]);
		volume.animation.add('10', [1]);
		volume.animation.add('0', [0]);
		volume.scaleSpr();
		volume.setPosition(coloredLevelSelect.x, coloredLevelSelect.y + coloredLevelSelect.height + 32);
		volume.ID = 2;
		add(volume);

		pageCont.push(volume);
		lowerPageCont.push(volume);

		clearSave = new Spr();
		clearSave.loadGraphic(Assets.getImagePath('settings/ClearSave'));
		clearSave.scaleSpr();
		clearSave.setPosition(discordRPC.x, volume.y);
		clearSave.ID = 3;
		add(clearSave);
		clearSavePos = new FlxPoint(clearSave.x, clearSave.y);

		pageCont.push(clearSave);
		lowerPageCont.push(clearSave);

		descriptionText = new FlxText(0, 0, FlxG.width, 'Monkeyballs', 16);
		descriptionText.alignment = 'center';
		add(descriptionText);

		cursor = new Spr(-3);

		if (FlxG.random.bool() && Global.previousState == 'TitleScreen' || cursorSkin == 2)
		{
			cursorSkin = 2;
			cursor.loadGraphic(Assets.getImagePath('settings/cursors/sinco'), true, 64, 64);
			cursor.color = 0x4eb10c;
			Global.changeDiscordRPCPresence('Powering their options', 'Settings Menu'); // electricity = power. Shut up
		}
		else
		{
			cursorSkin = 1;
			cursor.loadGraphic(Assets.getImagePath('settings/cursors/port'), true, 64, 64);
			cursor.color = 0x4e0c6f;
			Global.changeDiscordRPCPresence('Sabotaging their options', 'Settings Menu');
		}

		cursor.animation.add('idle', [0], 24);
		cursor.animation.add('select', [1], 24);
		cursor.animation.play('idle');
		add(cursor);

		if (Global.previousState == 'ClearSaveScreen')
		{
			FlxG.sound.music.fadeIn(1);

			coloredLevelSelect.alpha = 0;
			discordRPC.alpha = 0;
			volume.alpha = 0;

			FlxTween.tween(coloredLevelSelect, {alpha: 1}, 1);
			FlxTween.tween(discordRPC, {alpha: 1}, 1);
			FlxTween.tween(volume, {alpha: 1}, 1);
		}
	}

	public var pageCont:Array<Spr> = [];
	public var lowerPageCont:Array<Spr> = [];

	override function update(elapsed:Float)
	{
		Global.playMenuMusic();
		super.update(elapsed);

		cursor.setPosition(FlxG.mouse.x - (cursor.width / 2), FlxG.mouse.y - (cursor.height / 2));
		cursor.animation.play('idle');

		coloredLevelSelect.animation.play(Std.string(FlxG.save.data.colored_levelSelect));
		#if DISCORDRPC
		discordRPC.animation.play(Std.string(FlxG.save.data.discord_rpc));
		#else
		discordRPC.animation.play(Std.string(false));
		#end
		volume.animation.play(Std.string(FlxMath.roundDecimal(FlxG.sound.volume * 100, 0)));

		if (Global.keyJustReleased(ESCAPE))
		{
			Global.switchState(new TitleScreen());
		}

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
							descriptionText.text = 'Discord RPC (${#if DISCORDRPC(FlxG.save.data.discord_rpc) ? 'enabled' : 'disabled' #else 'unsupported' #end}) - Enables Rich Presence Support on Discord';
						case 2:
							descriptionText.text = 'Volume (${FlxMath.roundDecimal(FlxG.sound.volume * 100, 0)}) - Sets the game volume';
						case 3:
							descriptionText.text = 'Clear Save - You will lose everything you hold dear to you in this game.';
					}
				}
				descriptionText.y = 0;
				if (lowerPageCont.contains(setting))
					descriptionText.y = FlxG.height - descriptionText.height;

				setting.scale.set(setting.scale.x - .1, setting.scale.y - .1);

				if (FlxG.mouse.justReleased)
				{
					var ps = true;

					switch (setting.ID)
					{
						case 0:
							FlxG.save.data.colored_levelSelect = !FlxG.save.data.colored_levelSelect;
						case 1:
							#if DISCORDRPC
							FlxG.save.data.discord_rpc = !FlxG.save.data.discord_rpc;

							if (FlxG.save.data.discord_rpc)
							{
								Discord.DiscordClient.initialize();
								Global.changeDiscordRPCPresence('Re-enabled', 'Settings Menu');
							}
							else
								Discord.DiscordClient.shutdown();
							#else
							ps = false;
							#end
						case 2:
							FlxG.sound.changeVolume(0.1);
							if (FlxG.sound.volume >= 1)
							{
								FlxG.sound.changeVolume(-1);
							}
							#if !html5
							FlxG.save.data.volume = FlxG.sound.volume;
							#else
							WebSave.volume = FlxG.sound.volume;
							#end
						case 3:
							FlxG.sound.music.fadeOut(1, 0, tween ->
							{
								Global.switchState(new ClearSaveScreen());
							});

							FlxTween.tween(coloredLevelSelect, {alpha: 0}, 1);
							FlxTween.tween(discordRPC, {alpha: 0}, 1);
							FlxTween.tween(volume, {alpha: 0}, 1);
					}

					if (ps)
						Global.playSoundEffect('blipSelect');

					FlxG.save.flush();
				}
			}
			if (cursor.animation.name != 'select')
				selected = -1;
		}
	}
}
