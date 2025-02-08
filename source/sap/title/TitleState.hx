package sap.title;

import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import mainmenu.MainMenu;

enum abstract TitleStates(Int) from Int to Int
{
	var INTRO = 0;
	var FLASH = 1;
	var DONE = 2;
}

class TitleState extends FlxState
{
	public static var CURRENT_STATE:TitleStates = INTRO;

	var charring:FlxSprite = new FlxSprite();
	var pressany:FlxSprite = new FlxSprite();
	var titlebg:FlxSprite = new FlxSprite();

	var sinco:TitleSinco = new TitleSinco();
	var port:TitlePort = new TitlePort();

	var versiontext:FlxText = new FlxText();

	override public function create()
	{
		titlebg.loadGraphic(FileManager.getImageFile('titlescreen/TitleBG'));
		Global.scaleSprite(titlebg, 2);
		titlebg.screenCenter(XY);
		titlebg.visible = false;
		add(titlebg);

		charring.loadGraphic(FileManager.getImageFile('titlescreen/CharacterRing'));
		Global.scaleSprite(charring, 0);
		charring.screenCenter(X);
		charring.y = -(charring.height * 2);
		add(charring);

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

		if (CURRENT_STATE == INTRO)
			Global.playSoundEffect('start-synth');

		pressanyTargY =  FlxG.height - (pressany.height * 2) - (16 * 2);

		versiontext.size = 16;
		versiontext.setPosition(5, 5);
		versiontext.text = 'v${Global.VERSION}';
		versiontext.color = FlxColor.BLACK;
		add(versiontext);

		super.create();
	}

	var transitioning:Bool = false;

	override public function update(elapsed:Float)
	{
		stateChecks();

		if (CURRENT_STATE == DONE)
		{
			if (FlxG.keys.justReleased.ANY && !transitioning)
			{
				transitioning = !transitioning;
				Global.playSoundEffect('blipSelect');
				FlxG.camera.flash(0xFFFFFF, 2);
				FlxFlicker.flicker(pressany, 3, 0.04, true, true, _flicker -> {
					FlxG.switchState(() -> new MainMenu());
				});
			}
		}

		super.update(elapsed);
	}
	
	public function stateChecks()
	{
		switch (CURRENT_STATE)
		{
			case INTRO:
				FlxTween.tween(charring, {y: charring.height + 16}, 1.0, {
					ease: FlxEase.sineOut,
					onComplete: _tween ->
					{
						FlxTimer.wait(1, () ->
						{
							FlxG.camera.flash(0xFFFFFF, 4);
							CURRENT_STATE = FLASH;
						});
					}
				});

			case FLASH:
				Global.playMenuMusic();

				pressany.y = pressanyTargY;
				titlebg.visible = true;

				FlxTimer.wait(5, () ->
				{
					CURRENT_STATE = DONE;
					pressany.visible = true;
					pressany.alpha = 0;

					FlxTween.tween(pressany, {alpha: 1}, 1);
				});

			case DONE:
				Global.playMenuMusic();
				
				if (pressany.y != pressanyTargY) pressany.y = pressanyTargY;
				if (!pressany.visible) pressany.visible = true;
				if (!titlebg.visible) titlebg.visible = true;
				if (charring.y != charring.height + 16) charring.y = charring.height + 16;

				randomBGChar(sinco, 6);
				randomBGChar(port, 4);
		}
	}

	var pressanyTargY:Float = 0;

	public function randomBGChar(char:FlxSprite, chance:Float)
	{
		if (FlxG.random.bool(chance) && !char.visible)
		{
			char.visible = true;
			char.y = FlxG.height - (32 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER);
			char.x = -(char.width * 2);
			FlxTween.tween(char, {x: FlxG.width + (char.width * 2)}, 2, {
				onComplete: _tween ->
				{
					FlxTimer.wait(FlxG.random.float(1, 4), () ->
					{
						char.visible = false;
					});
				}
			});
		}
	}
}
