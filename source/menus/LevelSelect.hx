package menus;

import flixel.tweens.FlxEase;
import levels.Tres;
import levels.StringQuest;
import levels.Osin;
import flixel.util.FlxTimer;
import backend.levelselect.LevelData;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;

class LevelSelect extends State
{
	final portPetX:Float = FlxG.width / 2;

	public var startLevelTimer:FlxTimer;

	public var sinco:Spr;
	public var port:Spr;

	var console:Spr;

	public var cursor:Spr;

	public var levelIcons:FlxTypedGroup<Spr>;
	public var levelCrowns:FlxTypedGroup<Spr>;
	public var levelNames:Array<String> = ['string-quest', 'osin', 'tres'];
	public var selectedLevel:Int = 0;

	override public function new(beatLvl:Bool = false)
	{
		super();

		/**
		 * if (beatLvl)
		 *	Global.camflash(0x6ff34e, 2);
		**/
	}

	override function create()
	{
		super.create();

		levelCrowns = new FlxTypedGroup<Spr>();
		add(levelCrowns);
		levelIcons = new FlxTypedGroup<Spr>();
		add(levelIcons);

		cursor = new Spr(-3);
		cursor.loadGraphic(Assets.getImagePath('levelSelect/cursor'), true, 64, 64);
		cursor.animation.add('idle', [0], 24);
		cursor.animation.add('select', [1], 24);
		cursor.animation.play('idle');

		for (i in 0...levelNames.length)
		{
			var levelIcon:Spr = new Spr(#if MOBILE_BUILD - 2 #else - 3 #end);
			var crown:Spr = new Spr(#if MOBILE_BUILD - 2 #else - 3 #end);
			levelIcon.loadGraphic(Assets.getImagePath('levelSelect/level_icons/blank'));
			crown.loadGraphic(Assets.getImagePath('levelSelect/crown'));

			var data:LevelData;

			try
			{
				data = Assets.getFileJsonContent('levels/${levelNames[i]}.json');
			}
			catch (e)
			{
				data = null;
			}

			if (data != null)
			{
				if (data.can_play)
					try
					{
						levelIcon.loadGraphic(Assets.getImagePath('levelSelect/level_icons/${levelNames[i]}'));
					}
					catch (e)
					{
						levelIcon.loadGraphic(Assets.getImagePath('levelSelect/level_icons/unknown'));
					}
				else
					levelIcon.loadGraphic(Assets.getImagePath('levelSelect/level_icons/locked'));

				if (FlxG.save.data.colored_levelSelect)
				{
					crown.color = 0xe2e25e;

					if (data.port_level)
						levelIcon.color = 0x4e0c6f;
					if (data.sinco_level)
						levelIcon.color = 0x4eb10c;

					if (data.color != null && data.color.length >= 3)
						levelIcon.color = FlxColor.fromRGB(data.color[0], data.color[1], data.color[2]);
				}
			}

			levelIcon.x = 0;
			#if MOBILE_BUILD
			levelIcon.x = (levelIcon.width / 4);
			#end
			levelIcon.x += (64 + 0) + (i * #if MOBILE_BUILD ((128 * 4) + (64 * 1)) #else (128 + 64) #end);

			levelIcon.screenCenter(Y);
			levelIcon.y -= levelIcon.height * (#if MOBILE_BUILD 2 #else 1 #end);

			crown.setPosition(levelIcon.x, levelIcon.y);

			levelIcon.scaleSpr();
			crown.scaleSpr();

			crown.ID = i;
			levelIcon.ID = i;

			#if !html5
			crown.visible = FlxG.save.data.levels_complete.contains(i + 1);
			#else
			crown.visible = WebSave.levels_complete.contains(i + 1);
			#end

			levelCrowns.add(crown);
			levelIcons.add(levelIcon);
		}

		console = new Spr(#if MOBILE_BUILD 0 #else -2 #end);
		console.loadGraphic(Assets.getImagePath('levelSelect/console'));
		console.scaleSpr();
		console.screenCenter(X);
		console.y = FlxG.height - console.height;

		sinco = new Spr(#if MOBILE_BUILD 0 #else -2 #end);
		port = new Spr(#if MOBILE_BUILD 0 #else -2 #end);

		sinco.loadGraphic(Assets.getImagePath('levelSelect/chars/sinco'), true, 128, 128);
		sinco.scaleSpr();
		sinco.screenCenter(X);
		sinco.y = FlxG.height - sinco.height;
		add(sinco);

		port.loadGraphic(Assets.getImagePath('levelSelect/chars/port'), true, 128, 128);
		port.scaleSpr();
		port.screenCenter(X);
		port.y = FlxG.height - port.height;
		add(port);

		sinco.animation.add('idle', [0], 24);
		sinco.animation.add('picked', [1, 1, 1, 1, 1], 1, false);
		sinco.animation.add('notpicked', [2, 2, 2, 2, 2], 1, false);
		sinco.animation.add('idle-pet', [3, 3, 3], 6, false);
		sinco.animation.add('picked-pet', [4, 4, 4], 6, false);
		sinco.animation.add('notpicked-pet', [5, 5, 5], 6, false);

		port.animation.add('idle', [0], 24);
		port.animation.add('picked', [1, 1, 1, 1, 1], 1, false);
		port.animation.add('notpicked', [2, 2, 2, 2, 2], 1, false);
		port.animation.add('idle-pet', [3, 3, 3], 6, false);
		port.animation.add('picked-pet', [4, 4, 4], 6, false);
		port.animation.add('notpicked-pet', [5, 5, 5], 6, false);

		port.animation.play('idle');
		sinco.animation.play('idle');

		if (FlxG.save.data.colored_levelSelect)
		{
			sinco.color = 0x4eb10c;
			port.color = 0x4e0c6f;
		}

		add(console);
		add(cursor);

		#if MOBILE_BUILD
		cursor.visible = false;
		#end

		message.size = 32;
		message.screenCenter();
		message.alignment = 'center';
		add(message);

		startLevelTimer = new FlxTimer();

		Global.changeDiscordRPCPresence('In the Level Select', 'Level Select');

		if (Global.previousState == 'Tres')
		{
			FlxG.sound.music.fadeOut(.25, 0, tween ->
			{
				FlxG.sound.music.stop();
				Global.playMenuMusic();
				FlxG.sound.music.fadeIn(.25);
			});
		}

		#if MOBILE_BUILD
		add(new backend.mobile.BackButton(new TitleScreen()));
		#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		Global.playMenuMusic();

		if (Global.keyJustReleased(ESCAPE))
		{
			Global.switchState(new TitleScreen());
		}

		cursor.setPosition(FlxG.mouse.x - (cursor.width / 2), FlxG.mouse.y - (cursor.height / 2));
		cursor.animation.play('idle');

		if (!startLevelTimer.active)
		{
			final psl = selectedLevel;
			selectedLevel = -1;
			for (icon in levelIcons.members)
			{
				var data:LevelData;

				try
				{
					data = Assets.getFileJsonContent('levels/${levelNames[icon.ID]}.json');
				}
				catch (e)
				{
					data = null;
				}

				if (data != null)
				{
					if (FlxG.save.data.colored_levelSelect)
					{
						if (data.port_level && data.sinco_level && (data.color == null || data.color.length < 3))
							icon.color = 0x4eb10c;
					}
				}

				icon.scaleSpr();
				if (cursor.overlaps(icon))
				{
					if (data != null)
						if (FlxG.save.data.colored_levelSelect)
						{
							if (data.port_level && data.sinco_level)
								icon.color = 0x4e0c6f;

							if (data.color != null && data.color.length >= 3)
								icon.color = FlxColor.fromRGB(data.color[0], data.color[1], data.color[2]);

							if (data.hover_color != null && data.hover_color.length >= 3)
								icon.color = FlxColor.fromRGB(data.hover_color[0], data.hover_color[1], data.hover_color[2]);
						}

					selectedLevel = icon.ID;
					icon.scale.set(icon.scale.x - .1, icon.scale.y - .1);
					cursor.animation.play('select');
				}
			}
		}

		for (crown in levelCrowns.members)
		{
			crown.scaleSpr();
			if (selectedLevel == crown.ID)
				crown.scale.set(crown.scale.x - .1, crown.scale.y - .1);
		}

		FlxG.watch.addQuick('selectedLevel', selectedLevel);

		if (!startLevelTimer.active && selectedLevel > -1 && FlxG.mouse.justReleased)
		{
			var data:LevelData;

			try
			{
				data = Assets.getFileJsonContent('levels/${levelNames[selectedLevel]}.json');
			}
			catch (e)
			{
				data = null;
			}

			sinco.animation.play('notpicked');
			port.animation.play('notpicked');
			if (data == null)
				flashMessage('Missing level file:\n\n"${levelNames[selectedLevel]}"');
			else
			{
				if (!data.can_play)
					flashMessage('Can\'t play');
				else
				{
					if (data.port_level)
						port.animation.play('picked');
					if (data.sinco_level)
						sinco.animation.play('picked');

					switch (levelNames[selectedLevel].toLowerCase())
					{
						case 'string-quest':
							flashMessage('String Quest');
						case 'osin':
							flashMessage('Vs Osin');
						case 'tres':
							flashMessage('Tres');
					}

					Global.playSoundEffect('blipSelect');

					startLevelTimer.start(10);
					FlxTimer.wait(1, () ->
					{
						switch (levelNames[selectedLevel].toLowerCase())
						{
							case 'string-quest': Global.switchState(new StringQuest());
							case 'osin': Global.switchState(new Osin());
							case 'tres':
								FlxG.sound.music.fadeOut(1, 0, tween ->
								{
									FlxG.sound.music.stop();
									Global.switchState(new Tres());
								});
						}
					});
				}
			}
		}

		if (sinco.animation.finished)
			sinco.animation.play('idle');
		if (port.animation.finished)
			port.animation.play('idle');

		if (cursor.overlaps(console))
		{
			var pos = (console.y + console.height / 4);

			if (cursor.y < (pos - 64))
				return;
			else
			{
				if (cursor.x > (portPetX) && cursor.y < pos)
					return;
			}
			if (cursor.y > FlxG.height - (console.height / 2) + 32)
			{
				return;
			}

			cursor.animation.play('select');

			if (FlxG.mouse.justReleased)
			{
				if (cursor.x < (portPetX))
				{
					Global.playSoundEffect('sinco-pet', 10);

					sinco.animation.play('${sinco.animation.name.split('-')[0]}-pet');
				}
				else if (cursor.x > (portPetX))
				{
					Global.playSoundEffect('port-pet');
					port.animation.play('${port.animation.name.split('-')[0]}-pet');
				}
			}
		}
	}

	public var message:FlxText = new FlxText();

	public function flashMessage(msg:String)
	{
		message.text = msg;
		message.alpha = 1;
		message.screenCenter();
		FlxTween.cancelTweensOf(message);
		FlxTween.tween(message, {alpha: 0}, 1, {startDelay: 1});
	}
}
