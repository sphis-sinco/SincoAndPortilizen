package menus;

import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.util.FlxCollision;
import flixel.text.FlxText;

class SettingsMenu extends State
{
	public var coloredLevelSelect:InteractableSpr;
	public var discordRPC:InteractableSpr;
	public var volume:InteractableSpr;
	public var clearSave:InteractableSpr;

	public static var clearSavePos:FlxPoint;

	public static var cursorSkin:Int;

	public var cursor:Spr;
	public var selected:Int = -1;

	public var descriptionText:FlxText;

	override function create()
	{
		super.create();

		coloredLevelSelect = new InteractableSpr('settings/ColoredLevelSelect');
		coloredLevelSelect.loadGraphic(Assets.getImagePath('settings/ColoredLevelSelect'), true, 64, 64);
		coloredLevelSelect.animation.add('false', [0]);
		coloredLevelSelect.animation.add('true', [1]);
		coloredLevelSelect.scaleOffset = #if !MOBILE_BUILD 0 #else 2 #end;
		coloredLevelSelect.scaleSpr();
		coloredLevelSelect.setPosition(32, 32);

		#if MOBILE_BUILD
		coloredLevelSelect.screenCenter(X);
		coloredLevelSelect.x -= (coloredLevelSelect.width / 2);
		#end

		coloredLevelSelect.ID = 0;
		add(coloredLevelSelect);

		pageCont.push(coloredLevelSelect);

		discordRPC = new InteractableSpr('settings/DiscordRPC');
		discordRPC.loadGraphic(Assets.getImagePath('settings/DiscordRPC'), true, 64, 64);
		discordRPC.animation.add('false', [0]);
		discordRPC.animation.add('true', [1]);
		discordRPC.scaleOffset = #if !MOBILE_BUILD 0 #else 2 #end;
		discordRPC.scaleSpr();
		discordRPC.setPosition(coloredLevelSelect.x + coloredLevelSelect.width + 32, coloredLevelSelect.y);
		discordRPC.ID = 1;

		discordRPC.color = 0x5e5ea0;
		#if !DISCORDRPC
		discordRPC.color = 0x4e4e4e;
		#end
		pageCont.push(discordRPC);
		add(discordRPC);

		volume = new InteractableSpr('settings/Volume');
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
		volume.scaleOffset = #if !MOBILE_BUILD 0 #else 2 #end;
		volume.scaleSpr();
		volume.setPosition(coloredLevelSelect.x, coloredLevelSelect.y + coloredLevelSelect.height + 32);
		volume.ID = 2;
		add(volume);

		pageCont.push(volume);
		lowerPageCont.push(volume);

		clearSave = new InteractableSpr('settings/ClearSave');
		clearSave.loadGraphic(Assets.getImagePath('settings/ClearSave'));
		clearSave.scaleOffset = #if !MOBILE_BUILD 0 #else 2 #end;
		clearSave.scaleSpr();
		clearSave.setPosition(discordRPC.x, volume.y);
		clearSave.ID = 3;
		add(clearSave);
		clearSavePos = new FlxPoint(clearSave.x, clearSave.y);

		pageCont.push(clearSave);
		lowerPageCont.push(clearSave);

		descriptionText = new FlxText(0, 0, FlxG.width, 'Monkeyballs', #if !MOBILE_BUILD 16 #else 32 #end);
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

		#if MOBILE_BUILD
		cursor.visible = false;
		#end

		if (Global.previousState == 'ClearSaveScreen')
		{
			FlxG.sound.music.fadeIn(1);

			coloredLevelSelect.alpha = 0;
			discordRPC.alpha = 0;
			volume.alpha = 0;
			descriptionText.alpha = 0;

			FlxTween.tween(coloredLevelSelect, {alpha: 1}, 1);
			FlxTween.tween(discordRPC, {alpha: 1}, 1);
			FlxTween.tween(volume, {alpha: 1}, 1);
			FlxTween.tween(descriptionText, {alpha: 1}, 1);
		}

		#if MOBILE_BUILD
		add(new backend.mobile.BackButton(new TitleScreen(), new FlxPoint(0, -64)));
		#end

		coloredLevelSelect.desiredPosition = coloredLevelSelect.getPosition();
		discordRPC.desiredPosition = discordRPC.getPosition();
		volume.desiredPosition = volume.getPosition();
		clearSave.desiredPosition = clearSave.getPosition();

		coloredLevelSelect.overlap.add(() ->
		{
			descriptionText.text = 'Colored Level Select (${(FlxG.save.data.colored_levelSelect) ? 'enabled' : 'disabled'}) - Enables Color on the Level Select';
		});
		discordRPC.overlap.add(() ->
		{
			descriptionText.text = 'Discord RPC (${#if DISCORDRPC(FlxG.save.data.discord_rpc) ? 'enabled' : 'disabled' #else 'unsupported' #end}) - Enables Rich Presence Support on Discord';
		});
		volume.overlap.add(() ->
		{
			descriptionText.text = 'Volume (${FlxMath.roundDecimal(FlxG.sound.volume * 100, 0)}) - Sets the game volume';
		});
		clearSave.overlap.add(() ->
		{
			descriptionText.text = 'Clear Save - You will lose everything you hold dear to you in this game.';
		});

		coloredLevelSelect.justReleased.add(() ->
		{
			FlxG.save.data.colored_levelSelect = !FlxG.save.data.colored_levelSelect;

			FlxG.save.flush();
		});

		discordRPC.justReleased.add(() -> {
			#if DISCORDRPC
			discordRPC.justReleased_soundPlay = true;
			FlxG.save.data.discord_rpc = !FlxG.save.data.discord_rpc;

			if (FlxG.save.data.discord_rpc)
			{
				Discord.DiscordClient.initialize();
				Global.changeDiscordRPCPresence('Re-enabled', 'Settings Menu');
			}
			else
				Discord.DiscordClient.shutdown();
			#else
			discordRPC.justReleased_soundPlay = false;
			#end

			FlxG.save.flush();
		});

		volume.justReleased.add(() ->
		{
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

			FlxG.save.flush();
		});
		volume.justReleased_soundPlay = false;

		clearSave.justReleased.add(() ->
		{
			if (coloredLevelSelect.alpha == 1)
			{
				clearSave.justReleased_soundPlay = true;
				FlxG.sound.music.fadeOut(1, 0, tween ->
				{
					Global.switchState(new ClearSaveScreen());
				});

				FlxTween.tween(coloredLevelSelect, {alpha: 0}, 1);
				FlxTween.tween(discordRPC, {alpha: 0}, 1);
				FlxTween.tween(volume, {alpha: 0}, 1);
				FlxTween.tween(descriptionText, {alpha: 0}, 1);
			}
			else
				clearSave.justReleased_soundPlay = false;
			
			FlxG.save.flush();
		});
	}

	public var pageCont:Array<InteractableSpr> = [];
	public var lowerPageCont:Array<InteractableSpr> = [];

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
			if (FlxCollision.pixelPerfectCheck(cursor, setting))
			{
				cursor.animation.play('select');

				if (selected != setting.ID)
					selected = setting.ID;

				setting.overlap.dispatch();

				descriptionText.y = 0;
				if (lowerPageCont.contains(setting))
					descriptionText.y = FlxG.height - descriptionText.height;
			}
			if (cursor.animation.name != 'select')
				selected = -1;
		}
	}
}
