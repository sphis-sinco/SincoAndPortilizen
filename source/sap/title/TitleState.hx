package sap.title;

import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import sap.mainmenu.MainMenu;

enum abstract TitleStates(Int) from Int to Int
{
	public var INTRO = 0;
	public var FLASH = 1;
	public var DONE = 2;
}

class TitleState extends State
{
	public static var CURRENT_STATE:TitleStates = INTRO;

	public static var CHARACTER_RING_CHARACTERS:FlxSprite;
	public static var CHARACTER_RING:FlxSprite;
	public static var PRESS_ANY_HINT:FlxSprite;
	public static var VOID_BACKGROUND:FlxSprite;

	public static var MINI_SINCO:TitleSinco;
	public static var MINI_PORTILIZEN:TitlePort;

	public static var versiontext:FlxText;

	public static dynamic function get_versiontext():String
	{
		return 'v${Global.VERSION}';
	}

	public static var SIDEBIT_MENU_BUTTON:SparrowSprite;

	override public function create():Void
	{
		MINI_SINCO = new TitleSinco();
		MINI_PORTILIZEN = new TitlePort();
		versiontext = new FlxText();

		transitioning = false;

		VOID_BACKGROUND = new FlxSprite();
		VOID_BACKGROUND.loadGraphic(FileManager.getImageFile('titlescreen/TitleBG'));
		Global.scaleSprite(VOID_BACKGROUND, 2);
		VOID_BACKGROUND.screenCenter(XY);
		VOID_BACKGROUND.visible = false;
		add(VOID_BACKGROUND);

		CHARACTER_RING_CHARACTERS = new FlxSprite();
		CHARACTER_RING_CHARACTERS.loadGraphic(FileManager.getImageFile('titlescreen/CharacterRing-characters'));
		Global.scaleSprite(CHARACTER_RING_CHARACTERS, 0);
		add(CHARACTER_RING_CHARACTERS);

		CHARACTER_RING = new FlxSprite();
		CHARACTER_RING.loadGraphic(FileManager.getImageFile('titlescreen/CharacterRing'));
		Global.scaleSprite(CHARACTER_RING, 0);
		CHARACTER_RING.screenCenter(X);
		CHARACTER_RING.y = -(CHARACTER_RING.height * 2);
		add(CHARACTER_RING);

		PRESS_ANY_HINT = new FlxSprite();
		PRESS_ANY_HINT.loadGraphic(FileManager.getImageFile('titlescreen/PressAnyToPlay'));
		Global.scaleSprite(PRESS_ANY_HINT, 0);
		PRESS_ANY_HINT.screenCenter(XY);
		PRESS_ANY_HINT.visible = false;
		add(PRESS_ANY_HINT);

		Global.scaleSprite(MINI_SINCO, 0);
		MINI_SINCO.visible = false;
		add(MINI_SINCO);

		Global.scaleSprite(MINI_PORTILIZEN, 0);
		MINI_PORTILIZEN.visible = false;
		add(MINI_PORTILIZEN);

		PRESS_ANY_HINT_TARGET_VERTICAL_POSITION = FlxG.height - (PRESS_ANY_HINT.height * 2) - (16 * 2);

		versiontext.size = 16;
		versiontext.setPosition(5, 5);
		versiontext.text = get_versiontext();
		versiontext.color = FlxColor.BLACK;
		add(versiontext);

		SIDEBIT_MENU_BUTTON = new SparrowSprite('titlescreen/SidebitMenuButton');
		SIDEBIT_MENU_BUTTON.setPosition(560, 515);
		SIDEBIT_MENU_BUTTON.addAnimationByPrefix('loopAnim', 'Ring spin', 24);
		add(SIDEBIT_MENU_BUTTON);
		SIDEBIT_MENU_BUTTON.visible = false;

		if (CURRENT_STATE == INTRO)
		{
			Global.playSoundEffect('start-synth');
		}

		super.create();

		Global.changeDiscordRPCPresence('In the title screen', null);
		// add(MedalData.unlockMedal('Welcome'));
	}

	public static var transitioning:Bool = false;

	override public function update(elapsed:Float):Void
	{
		CHARACTER_RING_CHARACTERS.setPosition(CHARACTER_RING.x, CHARACTER_RING.y);
		stateChecks();

		if (CURRENT_STATE == DONE)
		{
			if (FlxG.mouse.overlaps(SIDEBIT_MENU_BUTTON))
			{
				if (FlxG.mouse.justReleased)
				{
					trace('Head to sidebit menu');
				}
			}

			if (!PRESS_ANY_HINT.visible)
			{
				PRESS_ANY_HINT.visible = true;
			}

			pressAny();
		}

		super.update(elapsed);
	}

	public static dynamic function stateChecks():Void
	{
		stateSwitchStatement();
	}

	public static dynamic function stateSwitchStatement():Void
	{
		switch (CURRENT_STATE)
		{
			case INTRO:
				introState();

			case FLASH:
				flashState();

			case DONE:
				doneState();
		}
	}

	public static dynamic function introState():Void
	{
		FlxTween.tween(CHARACTER_RING, {y: CHARACTER_RING.height + 16}, 1.0, {
			ease: FlxEase.sineOut,
			onComplete: introStateDone()
		});
	}

	public static dynamic function introStateDone():TweenCallback
	{
		return _tween ->
		{
			FlxTimer.wait(1, () ->
			{
				CURRENT_STATE = FLASH;
			});
		}
	}

	public static dynamic function flashState():Void
	{
		if (CURRENT_STATE == FLASH)
		{
			FlxG.camera.flash(0xFFFFFF, 4);
		}
		Global.playMenuMusic();

		PRESS_ANY_HINT.y = PRESS_ANY_HINT_TARGET_VERTICAL_POSITION;
		VOID_BACKGROUND.visible = true;

		CURRENT_STATE = DONE;
		PRESS_ANY_HINT.visible = true;
		SIDEBIT_MENU_BUTTON.visible = true;
	}

	public static dynamic function doneState():Void
	{
		Global.playMenuMusic();

		if (PRESS_ANY_HINT.y != PRESS_ANY_HINT_TARGET_VERTICAL_POSITION)
		{
			PRESS_ANY_HINT.y = PRESS_ANY_HINT_TARGET_VERTICAL_POSITION;
		}
		if (!PRESS_ANY_HINT.visible)
		{
			PRESS_ANY_HINT.visible = true;
		}
		if (!SIDEBIT_MENU_BUTTON.visible)
		{
			SIDEBIT_MENU_BUTTON.visible = true;
		}

		if (!VOID_BACKGROUND.visible)
		{
			VOID_BACKGROUND.visible = true;
		}

		if (CHARACTER_RING.y != CHARACTER_RING.height + 16)
		{
			CHARACTER_RING.y = CHARACTER_RING.height + 16;
		}

		randomBGChar(MINI_SINCO, 6);
		randomBGChar(MINI_PORTILIZEN, 4);
	}

	public static dynamic function pressAny():Void
	{
		if (FlxG.keys.justReleased.ANY && !transitioning)
		{
			transitioning = !transitioning;
			Global.playSoundEffect('blipSelect');
			FlxG.camera.flash(0xFFFFFF, 2);
			FlxFlicker.flicker(PRESS_ANY_HINT, 3, 0.04, true, true, _flicker ->
			{
				FlxG.switchState(() -> new MainMenu());
			});
		}
	}

	public static var PRESS_ANY_HINT_TARGET_VERTICAL_POSITION:Float = 0;

	public static dynamic function randomBGChar(char:FlxSprite, chance:Float):Void
	{
		if (FlxG.random.bool(chance) && !char.visible)
		{
			char.visible = true;
			char.y = FlxG.height - (32 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER);
			char.x = -(char.width * 2);
			FlxTween.tween(char, {x: FlxG.width + (char.width * 2)}, 2, {
				onComplete: charDisappear(char)
			});
		}
	}

	public static dynamic function charDisappear(char:FlxSprite):TweenCallback
	{
		return _tween ->
		{
			charDisWait(char);
		}
	}

	public static dynamic function charDisWait(char:FlxSprite):Void
	{
		FlxTimer.wait(FlxG.random.float(1, 4), () ->
		{
			char.visible = false;
		});
	}
}
