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
	var INTRO = 0;
	var FLASH = 1;
	var DONE = 2;
}

class TitleState extends State
{
	public static var CURRENT_STATE:TitleStates = INTRO;

	public static var CHARRING:FlxSprite = new FlxSprite();
	public static var PRESS_ANY_BUTTON:FlxSprite = new FlxSprite();
	public static var TITLE_BG:FlxSprite = new FlxSprite();

	public static var SINCO:TitleSinco = new TitleSinco();
	public static var PORTILIZEN:TitlePort = new TitlePort();

	public static var VERSION_TEXT:FlxText = new FlxText();

        public static dynamic function get_versiontext():String
        {
                return 'v${Global.VERSION}';
        }

	override public function create()
	{
		TITLE_BG.loadGraphic(FileManager.getImageFile('titlescreen/TITLE_BG'));
		Global.scaleSprite(TITLE_BG, 2);
		TITLE_BG.screenCenter(XY);
		TITLE_BG.visible = false;
		add(TITLE_BG);

		CHARRING.loadGraphic(FileManager.getImageFile('titlescreen/CharacterRing'));
		Global.scaleSprite(CHARRING, 0);
		CHARRING.screenCenter(X);
		CHARRING.y = -(CHARRING.height * 2);
		add(CHARRING);

		PRESS_ANY_BUTTON.loadGraphic(FileManager.getImageFile('titlescreen/PRESS_ANY_BUTTONToPlay'));
		Global.scaleSprite(PRESS_ANY_BUTTON, 0);
		PRESS_ANY_BUTTON.screenCenter(XY);
		PRESS_ANY_BUTTON.visible = false;
		add(PRESS_ANY_BUTTON);

		Global.scaleSprite(SINCO, 0);
		SINCO.visible = false;
		add(SINCO);

		Global.scaleSprite(PORTILIZEN, 0);
		PORTILIZEN.visible = false;
		add(PORTILIZEN);

		if (CURRENT_STATE == INTRO)
			Global.playSoundEffect('start-synth');

		PRESS_ANY_BUTTONTargY = FlxG.height - (PRESS_ANY_BUTTON.height * 2) - (16 * 2);

		VERSION_TEXT.size = 16;
		VERSION_TEXT.setPosition(5, 5);
		VERSION_TEXT.text = get_versiontext();
		VERSION_TEXT.color = FlxColor.BLACK;
		add(VERSION_TEXT);

		super.create();
                
                Global.changeDiscordRPCPresence('In the title screen', null);
	}

	var transitioning:Bool = false;

	override public function update(elapsed:Float)
	{
		stateChecks();

		if (CURRENT_STATE == DONE)
		{
			pressany();
		}

		super.update(elapsed);
	}

	public function stateChecks()
	{
		stateSwitchStatement();
	}

	public function stateSwitchStatement()
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

	public function introState()
	{
		FlxTween.tween(CHARRING, {y: CHARRING.height + 16}, 1.0, {
			ease: FlxEase.sineOut,
			onComplete: introStateDone()
		});
	}

	public function introStateDone():TweenCallback
	{
		return _tween ->
		{
			FlxTimer.wait(1, () ->
			{
				FlxG.camera.flash(0xFFFFFF, 4);
				CURRENT_STATE = FLASH;
			});
		}
	}

	public function flashState()
	{
		Global.playMenuMusic();

		PRESS_ANY_BUTTON.y = PRESS_ANY_BUTTONTargY;
		TITLE_BG.visible = true;

		FlxTimer.wait(5, () ->
		{
			CURRENT_STATE = DONE;
			PRESS_ANY_BUTTON.visible = true;
			PRESS_ANY_BUTTON.alpha = 0;

			FlxTween.tween(PRESS_ANY_BUTTON, {alpha: 1}, 1);
		});
	}

	public function doneState()
	{
		Global.playMenuMusic();

		if (PRESS_ANY_BUTTON.y != PRESS_ANY_BUTTONTargY)
			PRESS_ANY_BUTTON.y = PRESS_ANY_BUTTONTargY;
		if (!PRESS_ANY_BUTTON.visible)
			PRESS_ANY_BUTTON.visible = true;
		if (!TITLE_BG.visible)
			TITLE_BG.visible = true;
		if (CHARRING.y != CHARRING.height + 16)
			CHARRING.y = CHARRING.height + 16;

		randomBGChar(SINCO, 6);
		randomBGChar(PORTILIZEN, 4);
	}

	public function pressany()
	{
		if (FlxG.keys.justReleased.ANY && !transitioning)
		{
			transitioning = !transitioning;
			Global.playSoundEffect('blipSelect');
			FlxG.camera.flash(0xFFFFFF, 2);
			FlxFlicker.flicker(PRESS_ANY_BUTTON, 3, 0.04, true, true, _flicker ->
			{
				FlxG.switchState(() -> new MainMenu());
			});
		}
	}

	var PRESS_ANY_BUTTONTargY:Float = 0;

	public function randomBGChar(char:FlxSprite, chance:Float)
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

	public function charDisappear(char:FlxSprite):TweenCallback
	{
		return _tween ->
		{
			charDisWait(char);
		}
	}

	public function charDisWait(char:FlxSprite)
	{
		FlxTimer.wait(FlxG.random.float(1, 4), () ->
		{
			char.visible = false;
		});
	}
}
