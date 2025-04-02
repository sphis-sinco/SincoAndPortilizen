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

	public static var charring_chars:FlxSprite;
	public static var charring:FlxSprite;
	public static var pressany:FlxSprite;
	public static var titlebg:FlxSprite;

	public static var sinco:TitleSinco;
	public static var port:TitlePort;

	public static var versiontext:FlxText;

	public static dynamic function get_versiontext():String
	{
		return 'v${Global.VERSION}';
	}

	override public function create()
	{
		sinco = new TitleSinco();
		port = new TitlePort();
		versiontext = new FlxText();

		transitioning = false;

		titlebg = new FlxSprite();
		titlebg.loadGraphic(FileManager.getImageFile('titlescreen/TitleBG'));
		Global.scaleSprite(titlebg, 2);
		titlebg.screenCenter(XY);
		titlebg.visible = false;
		add(titlebg);

		charring_chars = new FlxSprite();
		charring_chars.loadGraphic(FileManager.getImageFile('titlescreen/CharacterRing-characters'));
		Global.scaleSprite(charring_chars, 0);
		add(charring_chars);

		charring = new FlxSprite();
		charring.loadGraphic(FileManager.getImageFile('titlescreen/CharacterRing'));
		Global.scaleSprite(charring, 0);
		charring.screenCenter(X);
		charring.y = -(charring.height * 2);
		add(charring);

		pressany = new FlxSprite();
		pressany.loadGraphic(FileManager.getImageFile('titlescreen/PressAnyToPlay'));
		Global.scaleSprite(pressany, 0);
		pressany.screenCenter(XY);
		pressany.visible = false;
		add(pressany);

		Global.scaleSprite(sinco, 0);
		sinco.visible = false;
		add(sinco);

		Global.scaleSprite(port, 0);
		port.visible = false;
		add(port);

		pressanyTargY = FlxG.height - (pressany.height * 2) - (16 * 2);

		versiontext.size = 16;
		versiontext.setPosition(5, 5);
		versiontext.text = get_versiontext();
		versiontext.color = FlxColor.BLACK;
		add(versiontext);

		if (CURRENT_STATE == INTRO)
			Global.playSoundEffect('start-synth');

		super.create();

		Global.changeDiscordRPCPresence('In the title screen', null);
	}

	public static var transitioning:Bool = false;

	override public function update(elapsed:Float)
	{
		charring_chars.setPosition(charring.x, charring.y);
		stateChecks();

		if (CURRENT_STATE == DONE)
		{
			if (!pressany.visible)
				pressany.visible = true;

			pressAny();
		}

		super.update(elapsed);
	}

	public static dynamic function stateChecks()
	{
		stateSwitchStatement();
	}

	public static dynamic function stateSwitchStatement()
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

	public static dynamic function introState()
	{
                MedalData.unlockMedal('Welcome');

		FlxTween.tween(charring, {y: charring.height + 16}, 1.0, {
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

	public static dynamic function flashState()
	{
		if (CURRENT_STATE == FLASH)
			FlxG.camera.flash(0xFFFFFF, 4);
		Global.playMenuMusic();

		pressany.y = pressanyTargY;
		titlebg.visible = true;

		CURRENT_STATE = DONE;
		pressany.visible = true;
	}

	public static dynamic function doneState()
	{
		Global.playMenuMusic();

		if (pressany.y != pressanyTargY)
			pressany.y = pressanyTargY;
		if (!pressany.visible)
			pressany.visible = true;

		if (!titlebg.visible)
			titlebg.visible = true;

		if (charring.y != charring.height + 16)
			charring.y = charring.height + 16;

		randomBGChar(sinco, 6);
		randomBGChar(port, 4);
	}

	public static dynamic function pressAny()
	{
		if (FlxG.keys.justReleased.ANY && !transitioning)
		{
			transitioning = !transitioning;
			Global.playSoundEffect('blipSelect');
			FlxG.camera.flash(0xFFFFFF, 2);
			FlxFlicker.flicker(pressany, 3, 0.04, true, true, _flicker ->
			{
				FlxG.switchState(() -> new MainMenu());
			});
		}
	}

	public static var pressanyTargY:Float = 0;

	public static dynamic function randomBGChar(char:FlxSprite, chance:Float)
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

	public static dynamic function charDisWait(char:FlxSprite)
	{
		FlxTimer.wait(FlxG.random.float(1, 4), () ->
		{
			char.visible = false;
		});
	}
}
