package menus;

import levels.StringQuest;
import flixel.util.FlxTimer;
import backend.levelselect.LevelData;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;

class LevelSelect extends State
{
	final portPetX:Float = FlxG.width / 2.25;

	public var startLevelTimer:FlxTimer;

	public var sinco:Spr;
	public var port:Spr;

	var console:Spr;

	public var cursor:Spr;

	public var levelIcons:FlxTypedGroup<Spr>;
	public var levelNames:Array<String> = ['string-quest', 'osin', 'tres']; // tres is Sinco v Port
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

		Global.changeDiscordRPCPresence('In the Level Select', null);

		levelIcons = new FlxTypedGroup<Spr>();
		add(levelIcons);

		cursor = new Spr(-3);
		cursor.loadGraphic(Assets.getImagePath('levelSelect/cursor'), true, 64, 64);
		cursor.animation.add('idle', [0], 24);
		cursor.animation.add('select', [1], 24);
		cursor.animation.play('idle');

		for (i in 0...levelNames.length)
		{
			var levelIcon:Spr = new Spr(-3);
			levelIcon.loadGraphic(Assets.getImagePath('levelSelect/level_icons/blank'));

			var data:LevelData;

			try
			{
				data = Assets.getFileJsonContent('levels/${levelNames[selectedLevel]}.json');
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
						levelIcon.loadGraphic(Assets.getImagePath('levelSelect/level_icons/${levelNames[selectedLevel]}'));
					}
					catch (e)
					{
						levelIcon.loadGraphic(Assets.getImagePath('levelSelect/level_icons/unknown'));
					}
				else
					levelIcon.loadGraphic(Assets.getImagePath('levelSelect/level_icons/locked'));
			}

			levelIcon.x = (64 + 32) + (i * (128 + 64));

			levelIcon.screenCenter(Y);
			levelIcon.y -= levelIcon.height * 1;

			levelIcon.scaleSpr();

			levelIcon.ID = i;
			levelIcons.add(levelIcon);
		}

		console = new Spr(-2);
		console.loadGraphic(Assets.getImagePath('levelSelect/console'));
		console.scaleSpr();
		console.screenCenter(X);
		console.y = FlxG.height - console.height;

		sinco = new Spr(-2);
		port = new Spr(-2);

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
		sinco.animation.add('not-picked', [2, 2, 2, 2, 2], 1, false);
		sinco.animation.add('pet', [3, 3, 3], 6, false);

		port.animation.add('idle', [0], 24);
		port.animation.add('picked', [1, 1, 1, 1, 1], 1, false);
		port.animation.add('not-picked', [2, 2, 2, 2, 2], 1, false);
		port.animation.add('pet', [3, 3, 3], 6, false);

		port.animation.play('idle');
		sinco.animation.play('idle');

		if (FlxG.save.data.colored_levelSelect)
		{
			sinco.color = 0x4eb10c;
			port.color = 0x4e0c6f;
		}

		add(console);
		add(cursor);

		message.size = 32;
		message.screenCenter();
		message.alignment = 'center';
		add(message);

		startLevelTimer = new FlxTimer(FlxTimer.globalManager);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		Global.playMenuMusic();

		if (FlxG.mouse.visible)
			FlxG.mouse.visible = false;

		cursor.setPosition(FlxG.mouse.x - (cursor.width / 2), FlxG.mouse.y - (cursor.height / 2));
		cursor.animation.play('idle');

		if (!startLevelTimer.active)
		{
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

			sinco.animation.play('not-picked');
			port.animation.play('not-picked');
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
					}

					startLevelTimer.start(1, timer ->
					{
						switch (levelNames[selectedLevel].toLowerCase())
						{
							case 'string-quest': Global.switchState(new StringQuest());
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

			cursor.animation.play('select');

			if (FlxG.mouse.justReleased)
				if (cursor.x < (portPetX))
					sinco.animation.play('pet');
				else if (cursor.x > (portPetX))
					port.animation.play('pet');
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
