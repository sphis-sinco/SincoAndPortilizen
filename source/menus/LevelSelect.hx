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

	public var sinco:InteractableSpr;
	public var port:InteractableSpr;

	var console:Spr;

	public var cursor:Spr;

	var levelIcon:InteractableSpr = new InteractableSpr('levelSelect/level_icons/blank');
	var crown:Spr = new Spr(#if MOBILE_BUILD (-2) #else (-3) #end);
	var levelData:LevelData;

	public static var levelsFolder:String = 'base/';

	public var levelNames:Array<String> = [];

	public var selectedLevel:Int = 0;

	public var directional_left:InteractableSpr;
	public var directional_right:InteractableSpr;

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

		switch (levelsFolder.toLowerCase().replace('/', ''))
		{
			case 'base':
				levelNames = ['string-quest', 'osin', 'tres'];
			case 'sidebits':
				levelNames = ['revenge'];
		}

		cursor = new Spr(-3);
		cursor.loadGraphic(Assets.getImagePath('levelSelect/cursor'), true, 64, 64);
		cursor.animation.add('idle', [0], 24);
		cursor.animation.add('select', [1], 24);
		cursor.animation.play('idle');

		levelIcon.scaleOffset = crown.scaleOffset;
		crown.loadGraphic(Assets.getImagePath('levelSelect/crown'));

		levelIcon.screenCenter(XY);
		#if MOBILE_BUILD
		levelIcon.x -= levelIcon.width / 2;
		#end
		levelIcon.y -= levelIcon.height * (#if MOBILE_BUILD 2 #else 1 #end);

		crown.setPosition(levelIcon.x, levelIcon.y);

		levelIcon.scaleSpr();
		crown.scaleSpr();

		levelIcon.overlap.add(() ->
		{
			cursor.animation.play('select');

			if (levelData != null)
				if (FlxG.save.data.colored_levelSelect)
				{
					if (levelData.port_level && levelData.sinco_level)
						levelIcon.color = 0x4e0c6f;

					if (levelData.color != null && levelData.color.length >= 3)
						levelIcon.color = FlxColor.fromRGB(levelData.color[0], levelData.color[1], levelData.color[2]);

					if (levelData.hover_color != null && levelData.hover_color.length >= 3)
						levelIcon.color = FlxColor.fromRGB(levelData.hover_color[0], levelData.hover_color[1], levelData.hover_color[2]);
				}
		});

		levelIcon.justReleased.add(() ->
		{
			if (!startLevelTimer.active && selectedLevel > -1)
			{
				sinco.animation.play('notpicked');
				port.animation.play('notpicked');
				if (levelData == null)
					flashMessage('Missing level file:\n\n"${levelNames[selectedLevel]}"');
				else
				{
					if (!levelData.can_play)
					{
						if (levelData.cant_play_message != null)
							flashMessage(levelData.cant_play_message);
						else
							flashMessage('Can\'t play');
					}
					else
					{
						if (levelData.port_level)
							port.animation.play('picked');
						if (levelData.sinco_level)
							sinco.animation.play('picked');

						if (levelData.can_play_message != null)
							flashMessage(levelData.can_play_message);

						Global.playSoundEffect('blipSelect');

						startLevelTimer.start(10);
						FlxTimer.wait(1, () ->
						{
							switch (levelNames[selectedLevel].toLowerCase())
							{
								case 'string-quest': Global.switchState(new StringQuest());
								case 'osin': Global.switchState(new Osin());
								case 'tres': Global.switchState(new Tres());
							}
						});
					}
				}
			}
		});

		add(crown);
		add(levelIcon);
		levelIcon.desiredPosition = levelIcon.getPosition();

		console = new Spr(#if MOBILE_BUILD 0 #else (-2) #end);
		console.loadGraphic(Assets.getImagePath('levelSelect/console'));
		console.scaleSpr();
		console.screenCenter(X);
		console.y = FlxG.height - console.height;

		sinco = new InteractableSpr('levelSelect/chars/sinco');
		sinco.scaleOffset = #if MOBILE_BUILD 0 #else (-2) #end;
		port = new InteractableSpr('levelSelect/chars/port');
		port.scaleOffset = #if MOBILE_BUILD 0 #else (-2) #end;

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

		sinco.desiredPosition = sinco.getPosition();
		port.desiredPosition = port.getPosition();

		sinco.justReleased_soundPlay = false;
		port.justReleased_soundPlay = false;

		sinco.justReleased.add(() ->
		{
			if (cursor.y > FlxG.height - (console.height / 2) + 32)
				return;
			if (cursor.x < (portPetX))
			{
				Global.playSoundEffect('sinco-pet', 10);

				sinco.animation.play('${sinco.animation.name.split('-')[0]}-pet');
			}
		});

		port.justReleased.add(() ->
		{
			if (cursor.y > FlxG.height - (console.height / 2) + 32)
				return;
			if (cursor.x > (portPetX))
			{
				Global.playSoundEffect('port-pet', 10);

				port.animation.play('${port.animation.name.split('-')[0]}-pet');
			}
		});

		sinco.overlap.add(() ->
		{
			if (cursor.y > FlxG.height - (console.height / 2) + 32)
				sinco.scaleSpr();
			if (cursor.x > (portPetX))
				sinco.scaleSpr();
		});
		port.overlap.add(() ->
		{
			if (cursor.y > FlxG.height - (console.height / 2) + 32)
				port.scaleSpr();
			if (cursor.x < (portPetX))
				port.scaleSpr();
		});

		if (FlxG.save.data.colored_levelSelect)
		{
			sinco.color = 0x4eb10c;
			port.color = 0x4e0c6f;
			crown.color = 0xe2e25e;
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
			Global.fadeToMusic('MenuTracks/Lado', 1.0, .25, .25);

		directional_left = new InteractableSpr('mobile/directional');
		directional_right = new InteractableSpr('mobile/directional');

		directional_left.angle = -90;
		directional_right.angle = 90;

		directional_left.screenCenter(X);
		directional_right.screenCenter(X);

		directional_left.x = directional_left.width;
		directional_right.x = FlxG.width - (directional_right.width * 4);

		directional_left.y = levelIcon.y;
		directional_right.y = levelIcon.y;

		directional_left.desiredPosition = directional_left.getPosition();
		directional_right.desiredPosition = directional_right.getPosition();

		directional_left.justReleased.add(() ->
		{
			if (!startLevelTimer.active && selectedLevel > -1)
				if (selectedLevel - 1 > -1)
					selectedLevel--;
		});
		directional_right.justReleased.add(() ->
		{
			if (!startLevelTimer.active && selectedLevel > -1)
				if ((selectedLevel + 1) < levelNames.length)
					selectedLevel++;
		});

		directional_left.justReleased_soundPlay = false;
		directional_right.justReleased_soundPlay = false;

		#if MOBILE_BUILD
		add(directional_left);
		add(directional_right);
		add(new backend.mobile.BackButton(new LevelFolderSelect()));
		#end
	}

	var psi = -1;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		Global.playMenuMusic();

		#if !html5
		crown.visible = FlxG.save.data.levels_complete.contains(levelNames[selectedLevel]);
		#else
		crown.visible = WebSave.levels_complete.contains(levelNames[selectedLevel]);
		#end

		crown.scaleOffset = levelIcon.scaleOffset;
		crown.scaleSpr();

		if (levelIcon.scale.x < (Global.DEFAULT_IMAGE_SCALE_MULTIPLIER + crown.scaleOffset))
			crown.scale.set(crown.scale.x - .1, crown.scale.y - .1);

		if (Global.keyJustReleased(ESCAPE))
			Global.switchState(new LevelFolderSelect());

		if (Global.keyJustReleased(LEFT))
			if (!startLevelTimer.active && selectedLevel > -1)
				if (selectedLevel - 1 > -1)
					selectedLevel--;
		if (Global.keyJustReleased(RIGHT))
			if (!startLevelTimer.active && selectedLevel > -1)
				if ((selectedLevel + 1) < levelNames.length)
					selectedLevel++;

		if (psi != selectedLevel)
		{
			psi = selectedLevel;
			try
			{
				levelData = Assets.getFileJsonContent('levels/$levelsFolder${levelNames[selectedLevel]}.json');
			}
			catch (e)
			{
				levelData = null;
			}

			if (levelData != null)
			{
				if (levelData.can_play)
					try
					{
						levelIcon.loadGraphic(Assets.getImagePath('levelSelect/level_icons/${levelNames[selectedLevel]}'));
					}
					catch (e)
					{
						levelIcon.loadGraphic(Assets.getImagePath('levelSelect/level_icons/unknown'));
					}
				else
					levelIcon.loadGraphic(Assets.getImagePath('levelSelect/level_icons/locked'));

				if (FlxG.save.data.colored_levelSelect)
				{
					if (levelData.port_level)
						levelIcon.color = 0x4e0c6f;
					if (levelData.sinco_level)
						levelIcon.color = 0x4eb10c;

					if (levelData.color != null && levelData.color.length >= 3)
						levelIcon.color = FlxColor.fromRGB(levelData.color[0], levelData.color[1], levelData.color[2]);
				}
			}
		}

		cursor.setPosition(FlxG.mouse.x - (cursor.width / 2), FlxG.mouse.y - (cursor.height / 2));
		cursor.animation.play('idle');

		if (!startLevelTimer.active)
		{
			if (levelData != null)
			{
				if (FlxG.save.data.colored_levelSelect)
				{
					if (levelData.port_level && levelData.sinco_level && (levelData.color == null || levelData.color.length < 3))
						levelIcon.color = 0x4eb10c;
				}
			}
		}

		FlxG.watch.addQuick('selectedLevel', selectedLevel);

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
