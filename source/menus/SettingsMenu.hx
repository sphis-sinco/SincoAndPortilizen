package menus;

import backend.translations.Translate;
import backend.SettingsData.SettingsDataSettingsItem;
import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.text.FlxText;

class SettingsMenu extends State
{
	public var settingsData:SettingsData;

	public var settingSpritemap:Map<String, InteractableSpr> = [];
	public var settingDataFields:Map<String, SettingsDataSettingsItem> = [];
	public var settingsGroup:FlxTypedSpriteContainer<InteractableSpr> = new FlxTypedSpriteContainer<InteractableSpr>();

	public static var clearSavePos:FlxPoint;

	public static var cursorSkin:Int;

	public var selected:Int = 0;

	public var descriptionText:FlxText;

	override function create()
	{
		super.create();

		FlxG.mouse.enabled = false;

		settingsData = Assets.getJsonFile('settings');
		add(settingsGroup);

		for (ID => setting in settingsData.settings)
		{
			if (setting == null)
				continue;

			var settingSpr = new InteractableSpr('splash');

			if (setting.animated)
			{
				settingSpr.loadGraphic(Assets.getImagePath('settings/${setting.asset}'), true, 64, 64);

				if (setting.type == TOGGLE)
				{
					settingSpr.animation.add('false', [0]);
					settingSpr.animation.add('true', [1]);
				}

				if (setting.type == INCREMENT)
				{
					var a = 0;

					for (i in 0...Math.floor(setting.max / 10) + 1)
					{
						settingSpr.animation.add('${i * 10}', [a]);

						a += 1;
					}
				}
			}
			else
				settingSpr.loadGraphic(Assets.getImagePath('settings/${setting.asset}'));

			settingSpr.scaleOffset = #if !MOBILE_BUILD 0 #else 2 #end;
			settingSpr.scaleOffset += .1; // the overlap scale
			settingSpr.scaleSpr();

			settingSpr.screenCenter();
			settingSpr.ID = ID;

			settingSpr.desiredPosition = settingSpr.getPosition();

			settingDataFields.set(setting.id, setting);
			settingSpritemap.set(setting.id, settingSpr);
			settingsGroup.add(settingSpr);

			settingSpr.overlap.add(() ->
			{
				descriptionText.text = Translate.getLine('settings.${setting.id}.displayKey', [
					Translate.getLine('settings.${setting.id}.name'),
					() ->
					{
						#if !DISCORDRPC
						if (setting.id == 'discordRPC')
							return Translate.getLine('settings.value_unsupported');
						#end

						if (setting.type == TOGGLE)
							return (Reflect.field(FlxG.save.data,
								setting.savefield) ? Translate.getLine('settings.value_enabled') : Translate.getLine('settings.value_disabled'));

						if (setting.type == INCREMENT)
							return Std.string(FlxMath.roundDecimal(Reflect.field(FlxG.save.data, setting.savefield) * 100, 0));

						return 'Monkey Testicles';
					},
					Translate.getLine('settings.${setting.id}.description'),
				]);
			});
		}

		if (settingSpritemap.exists('discordRPC'))
		{
			settingSpritemap.get('discordRPC').color = 0x5e5ea0;
			#if !DISCORDRPC settingSpritemap.get('discordRPC').color = 0x4e4e4e; #end
		}

		clearSavePos = new FlxPoint(settingSpritemap.get('clearSave')?.x, settingSpritemap.get('clearSave')?.y);

		descriptionText = new FlxText(0, 0, FlxG.width, 'Monkey Testicles', #if !MOBILE_BUILD 16 #else 32 #end);
		descriptionText.alignment = 'center';
		add(descriptionText);

		if (FlxG.random.bool() && Global.previousState == 'TitleScreen' || cursorSkin == 2)
		{
			cursorSkin = 2;
			Global.changeDiscordRPCPresence('Powering their options', 'Settings Menu'); // electricity = power. Shut up // no
		}
		else
		{
			cursorSkin = 1;
			Global.changeDiscordRPCPresence('Sabotaging their options', 'Settings Menu');
		}

		#if MOBILE_BUILD
		cursor.visible = false;
		#end

		if (Global.previousState == 'ClearSaveScreen')
		{
			FlxG.sound.music.fadeIn(1);

			for (setting => settingSpr in settingSpritemap)
				if (setting != 'clearSave')
				{
					settingSpr.alpha = 0;
					FlxTween.tween(settingSpr, {alpha: 1}, 1);
				}

			descriptionText.alpha = 0;
			FlxTween.tween(descriptionText, {alpha: 1}, 1);
		}

		#if MOBILE_BUILD
		add(new backend.mobile.BackButton(new TitleScreen(), new FlxPoint(0, -64)));
		#end

		settingSpritemap.get('coloredLevelSelect').justReleased.add(() ->
		{
			FlxG.save.data.colored_levelSelect = !FlxG.save.data.colored_levelSelect;

			FlxG.save.flush();
		});

		settingSpritemap.get('discordRPC').justReleased.add(() ->
		{
			#if DISCORDRPC
			settingSpritemap.get('discordRPC').justReleased_soundPlay = true;
			FlxG.save.data.discord_rpc = !FlxG.save.data.discord_rpc;

			if (FlxG.save.data.discord_rpc)
			{
				Discord.DiscordClient.initialize();
				Global.changeDiscordRPCPresence('Re-enabled', 'Settings Menu');
			}
			else
				Discord.DiscordClient.shutdown();
			#else
			settingSpritemap.get('discordRPC').justReleased_soundPlay = false;
			#end

			FlxG.save.flush();
		});

		settingSpritemap.get('volume').justReleased.add(() ->
		{
			FlxG.sound.changeVolume(0.1);
			if (FlxG.sound.volume >= 1)
				Global.setMasterVolume(0);

			FlxG.save.flush();
		});
		settingSpritemap.get('volume').justReleased_soundPlay = false;

		settingSpritemap.get('clearSave').justReleased.add(() ->
		{
			if (settingSpritemap.get(settingsData.settings[0].id)?.alpha == 1)
			{
				settingSpritemap.get('clearSave').justReleased_soundPlay = true;
				FlxG.sound.music.fadeOut(1, 0, tween ->
				{
					Global.switchState(new ClearSaveScreen());
				});

				for (setting => settingSpr in settingSpritemap)
					if (setting != 'clearSave')
						FlxTween.tween(settingSpr, {alpha: 0}, 1);

				FlxTween.tween(descriptionText, {alpha: 0}, 1);
			}
			else
				settingSpritemap.get('clearSave').justReleased_soundPlay = false;

			FlxG.save.flush();
		});
	}

	override function update(elapsed:Float)
	{
		Global.playMenuMusic();
		super.update(elapsed);

		if (Global.anyKeysJustReleased([A, D, LEFT, RIGHT]))
		{
			if (Global.anyKeysJustReleased([A, LEFT]))
				selected--;
			if (Global.anyKeysJustReleased([D, RIGHT]))
				selected++;
		}

		if (selected < 0)
			selected = settingsGroup.members.length - 1;
		if (selected > settingsGroup.members.length - 1)
			selected = 0;

		for (settingID => setting in settingDataFields)
		{
			#if DISCORDRPC
			if (settingID == 'discordRPC')
			{
				settingSpritemap.get(settingID).animation.play('false');
				continue;
			}
			#end

			if (setting.type == TOGGLE)
				settingSpritemap.get(settingID).animation.play(Std.string(Reflect.field(FlxG.save.data, setting.savefield)));
			if (setting.type == INCREMENT)
				settingSpritemap.get(settingID).animation.play(Std.string(FlxMath.roundDecimal(Reflect.field(FlxG.save.data, setting.savefield) * 100, 0)));
		}

		if (Global.keyJustReleased(ESCAPE))
		{
			Global.switchState(new TitleScreen());
		}

		descriptionText.text = '';
		for (setting in settingsGroup.members)
		{
			if (selected == setting.ID)
			{
				setting.visible = true;
				setting.overlap.dispatch();

				if (Global.keyJustPressed(ENTER))
					setting.justPressed.dispatch();
				if (Global.keyJustReleased(ENTER))
					setting.justReleased.dispatch();
			}
			else
				setting.visible = false;
		}

		descriptionText.y = (FlxG.height * 0.9) - descriptionText.height;
	}
}
