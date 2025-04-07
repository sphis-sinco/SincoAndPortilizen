package sap.worldmap;

import sap.mainmenu.MainMenu;
import sap.stages.stage1.Stage1;
import sap.stages.stage2.Stage2;
import sap.stages.stage4.Stage4;

class Worldmap extends State
{
	public static var character:MapCharacter;
	public static var charWheel:CharacterWheel;

	public static var current_level:Int = 1;

	public static var mapGRP:FlxTypedGroup<FlxSprite>;

	public static var implementedLevels(get, never):Map<String, Array<Bool>>;

	static function get_implementedLevels():Map<String, Array<Bool>>
	{
		return ["sinco" => [true, true, false], "port" => [true, false, false]];
	}

	public static var DIFFICULTY:String = StageGlobals.NORMAL_DIFF;
	public static var difficultySprite:SparrowSprite;

	override public function new(char:String = "Sinco"):Void
	{
		super();

		charWheel = new CharacterWheel();
		character = new MapCharacter(char);
		mapGRP = new FlxTypedGroup<FlxSprite>();
		difficultySprite = new SparrowSprite('levelselect/difficulties', 0, 0);
	}

	override function create():Void
	{
		super.create();

		var bg:FlxSprite = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height);
		add(bg);

		character.screenCenter();
		character.x = 32 + character.width;
		mapTileXPosThing = character.getGraphicMidpoint().x;

		makeMap();

		add(mapGRP);
		add(character);

		charWheel.screenCenter(X);
		charWheel.y = charWheel.height + 16;

		charWheel.animation.play('${character.lowercase_char()}');

		add(charWheel);

		Global.changeDiscordRPCPresence('In the worldmap as ${character.char}', null);

		if (current_level > 1)
		{
			character.x += 256 * (current_level - 1);
		}

		difficultySprite.addAnimationByPrefix('easy', 'easy', 24);
		difficultySprite.addAnimationByPrefix('normal', 'normal', 24);
		difficultySprite.addAnimationByPrefix('hard', 'hard', 24);
		difficultySprite.addAnimationByPrefix('extreme', 'extreme', 24);

		difficultySprite.screenCenter();
		Global.scaleSprite(difficultySprite);
		difficultySprite.y += (difficultySprite.height * StageGlobals.DISMx2);
		add(difficultySprite);
	}

	public static var mapTileXPosThing:Float = 0;

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (difficultySprite.animation.name != DIFFICULTY.toLowerCase())
		{
			difficultySprite.playAnimation(DIFFICULTY);
		}

		if (FlxG.keys.anyJustReleased([LEFT, RIGHT]) && character.animationname() != 'run')
		{
			characterMove();
		}

		if (FlxG.keys.anyJustReleased([UP, DOWN]))
		{
			difficultyChange();
		}

		if (FlxG.keys.justReleased.ENTER && character.animationname() == 'idle')
		{
			playLevel();
		}

		if (FlxG.keys.justReleased.SPACE && canSwap)
		{
			swap();
		}
	}

	public dynamic function difficultyChange():Void
	{
		var down:Bool = !FlxG.keys.justReleased.UP;

		if (DIFFICULTY == StageGlobals.EASY_DIFF)
		{
			DIFFICULTY = (down) ? StageGlobals.EXTREME_DIFF : StageGlobals.NORMAL_DIFF;
		}
		else if (DIFFICULTY == StageGlobals.NORMAL_DIFF)
		{
			DIFFICULTY = (down) ? StageGlobals.EASY_DIFF : StageGlobals.HARD_DIFF;
		}
		else if (DIFFICULTY == StageGlobals.HARD_DIFF)
		{
			DIFFICULTY = (down) ? StageGlobals.NORMAL_DIFF : StageGlobals.EXTREME_DIFF;
		}
		else if (DIFFICULTY == StageGlobals.EXTREME_DIFF)
		{
			DIFFICULTY = (down) ? StageGlobals.HARD_DIFF : StageGlobals.EASY_DIFF;
		}
	}

	public dynamic function characterMove():Void
	{
		canSwap = false;
		character.flipX = FlxG.keys.justReleased.LEFT;

		current_level += (character.flipX) ? -1 : 1;
		if (current_level > 3)
		{
			current_level -= 1;
			canSwap = true;
			return;
		}

		character.animation.play('run');
		FlxTween.tween(character, {x: character.x + ((character.flipX) ? -256 : 256)}, 1, {
			onComplete: characterMoveDone()
		});
	}

	public dynamic function characterMoveDone():TweenCallback
	{
		return tween ->
		{
			canSwap = true;
			character.animation.play('idle');

			if (current_level < 1)
			{
				FlxG.switchState(() -> new MainMenu());
				current_level += 1;
			}
		}
	}

	public dynamic function playLevel():Void
	{
		switch (current_level)
		{
			// TODO: implement level unlocking PLEASE
			case 1:
				level1();
			case 2:
				level2();
		}
	}

	public dynamic function level1():Void
	{
		FlxG.switchState(() -> ((character.lowercase_char() == 'sinco') ? new Stage1(DIFFICULTY) : new Stage4(DIFFICULTY)));
	}

	public dynamic function level2():Void
	{
		FlxG.switchState(() -> (new Stage2(DIFFICULTY)));
	}

	public dynamic function swap():Void
	{
		canSwap = false;
		charWheel.animation.play('${character.lowercase_char()}-${character.swappedchar().toLowerCase()}');

		FlxTimer.wait(2 / 12, () ->
		{
			swapWaitDone();
		});
	}

	public dynamic function swapWaitDone():Void
	{
		Global.changeDiscordRPCPresence('In the worldmap as ${character.swappedchar()}', null);

		FlxG.camera.flash(0xffffff, 1, () ->
		{
			canSwap = true;
		});
		for (tile in mapGRP)
		{
			tile.destroy();
			mapGRP.remove(tile);
		}
		character.swapCharacter();
		character.animation.play('idle');
		makeMap();
	}

	public static var canSwap:Bool = true;

	public dynamic function makeMap():Void
	{
		var i:Int = 0;
		while (i < 3)
		{
			makeNewTile(i);

			i++;
		}
	}

	public dynamic function makeNewTile(i:Int):Void
	{
		// TODO: change these to use MapTile once you figure out the bug
		// ?: What bug? lol.

		var level:FlxSprite = new FlxSprite(mapTileXPosThing - 12 + (i * 256), character.getGraphicMidpoint().y);
		var tileColor:FlxColor = FlxColor.BLACK;

		if (implementedLevels.get(character.lowercase_char())[i])
		{
			var addition:Int = 0;

			if (character.lowercase_char() == 'port')
			{
				addition = 3;
			}

			tileColor = FlxColor.RED;

			// * TODO (DONE?): implement color change for when a level is finished
			if (SaveManager.getGameplaystatus().levels_complete.contains((i + 1) + addition))
			{
				tileColor = FlxColor.LIME;
			}
		}

		level.makeGraphic(24, 24, tileColor);

		mapGRP.add(level);
	}
}
