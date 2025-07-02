package sap.title;

import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import funkin.graphics.shaders.AdjustColorShader;
import sap.mainmenu.MainMenu;

enum abstract TitleStates(Int) from Int to Int
{
	public var DEBUG = -1;
	public var INTRO = 0;
	public var FLASH = 1;
	public var DONE = 2;
}

class TitleState extends State
{
	public static var CURRENT_STATE:TitleStates = (Global.DEBUG_BUILD) ? DEBUG : INTRO;

	public static var CHARACTER_RING_CHARACTERS:FlxSprite;
	public static var CHARACTER_RING:FlxSprite;
	public static var PRESS_ANY_HINT:FlxSprite;
	public static var VOID_BACKGROUND:FlxSprite;

	public static var MINI_SINCO:TitleSinco;
	public static var MINI_PORTILIZEN:TitlePort;

	public static var VERSION_TEXT:FlxText;

	public static var CHARACTER_RING_CHARS_SHADER:AdjustColorShader;

	override public function create():Void
	{
		CHARACTER_RING_CHARS_SHADER = new AdjustColorShader();

		MINI_SINCO = new TitleSinco();
		MINI_PORTILIZEN = new TitlePort();
		VERSION_TEXT = new FlxText();

		HEADING_TO_MAINMENU = false;

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
		CHARACTER_RING_CHARACTERS.shader = CHARACTER_RING_CHARS_SHADER;

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

		VERSION_TEXT.size = 12;
		VERSION_TEXT.setPosition(5, 5);
		VERSION_TEXT.text = '${SAPVersion.getVer().replace('Sinco and Portilizen', 'SAP')}'
			+ '\nModding API v${ModFolderManager.SUPPORTED_MODDING_API_VERSIONS[ModFolderManager.SUPPORTED_MODDING_API_VERSIONS.length - 1]}';
		VERSION_TEXT.color = FlxColor.BLACK;
		VERSION_TEXT.visible = false;
		add(VERSION_TEXT);

		if (CURRENT_STATE == INTRO || CURRENT_STATE == DEBUG)
		{
			if (CURRENT_STATE == INTRO)
			{
				introStuff();
			}
			else if (CURRENT_STATE == DEBUG)
			{
				FlxTimer.wait(1, function()
				{
					introStuff();
					CURRENT_STATE = INTRO;
				});
			}
		}

		super.create();

		Global.changeDiscordRPCPresence('In the title screen', null);
		TryCatch.tryCatch(function()
		{
			add(MedalData.unlockMedal('Welcome'));
		});

		stickerTransitionClear();
	}

	override function postCreate()
	{
		super.postCreate();

		updateFunctionBasic();
	}

	public static function introStuff():Void
	{
		Global.playSoundEffect('start-synth');
		CHARACTER_RING_CHARS_SHADER.brightness = -255;
	}

	public static function updateFunctionBasic():Void
	{
		CHARACTER_RING_CHARACTERS.setPosition(CHARACTER_RING.x, CHARACTER_RING.y);
		stateChecks();
	}

	public static var HEADING_TO_MAINMENU:Bool = false;

	override public function update(elapsed:Float):Void
	{
		updateFunctionBasic();

		if (CURRENT_STATE == DONE)
		{
			if (!PRESS_ANY_HINT.visible)
			{
				PRESS_ANY_HINT.visible = true;
			}

			pressAny();
		}

		super.update(elapsed);
	}

	public static function stateChecks():Void
	{
		switch (CURRENT_STATE)
		{
			case DEBUG:
				Global.pass();

			case INTRO:
				introState();

			case FLASH:
				flashState();

			case DONE:
				doneState();
		}
	}

	public static function introState():Void
	{
		FlxTween.tween(CHARACTER_RING_CHARS_SHADER, {brightness: 0}, .75, {
			ease: FlxEase.smoothStepOut,
			startDelay: .25
		});

		FlxTween.tween(CHARACTER_RING, {y: CHARACTER_RING.height + 16}, 1.0, {
			ease: FlxEase.sineOut,
			onComplete: introStateDone()
		});
	}

	public static function introStateDone():TweenCallback
	{
		return _tween ->
		{
			FlxTimer.wait(1, () ->
			{
				CURRENT_STATE = FLASH;
			});
		}
	}

	public static function flashState():Void
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
		VERSION_TEXT.visible = true;
	}

	public static function doneState():Void
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
		if (!VERSION_TEXT.visible)
		{
			VERSION_TEXT.visible = true;
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

	public static function pressAny():Void
	{
		if (Global.keyJustReleased(ANY) && !HEADING_TO_MAINMENU)
		{
			HEADING_TO_MAINMENU = true;
			Global.playSoundEffect('blipSelect');
			FlxG.camera.flash(0xFFFFFF, 2);
			FlxTimer.wait(2, function()
			{
				Global.switchState(new MainMenu());
			});
		}
	}

	public static var PRESS_ANY_HINT_TARGET_VERTICAL_POSITION:Float = 0;

	public static function randomBGChar(char:FlxSprite, chance:Float):Void
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

	public static function charDisappear(char:FlxSprite):TweenCallback
	{
		return _tween ->
		{
			charDisWait(char);
		}
	}

	public static function charDisWait(char:FlxSprite):Void
	{
		FlxTimer.wait(FlxG.random.float(1, 4), () ->
		{
			char.visible = false;
		});
	}
}
