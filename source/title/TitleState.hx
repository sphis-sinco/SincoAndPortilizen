package title;

import flixel.effects.FlxFlicker;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
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

	override public function create()
	{
		titlebg.loadGraphic(FileManager.getImageFile('titlescreen/TitleBG'));
		titlebg.scale.set(Global.DEFAULT_IMAGE_SCALE_MULTIPLIER + 2, Global.DEFAULT_IMAGE_SCALE_MULTIPLIER + 2);
		titlebg.screenCenter(XY);
		titlebg.visible = false;
		add(titlebg);

		charring.loadGraphic(FileManager.getImageFile('titlescreen/CharacterRing'));
		charring.scale.set(Global.DEFAULT_IMAGE_SCALE_MULTIPLIER, Global.DEFAULT_IMAGE_SCALE_MULTIPLIER);
		charring.screenCenter(X);
		charring.y = -(charring.height * 2);
		add(charring);

		pressany.loadGraphic(FileManager.getImageFile('titlescreen/PressAnyToPlay'));
		pressany.scale.set(Global.DEFAULT_IMAGE_SCALE_MULTIPLIER, Global.DEFAULT_IMAGE_SCALE_MULTIPLIER);
		pressany.screenCenter(XY);
		pressany.visible = false;
		add(pressany);

		sinco.scale.set(Global.DEFAULT_IMAGE_SCALE_MULTIPLIER, Global.DEFAULT_IMAGE_SCALE_MULTIPLIER);
		sinco.visible = false;
		add(sinco);

		port.scale.set(Global.DEFAULT_IMAGE_SCALE_MULTIPLIER, Global.DEFAULT_IMAGE_SCALE_MULTIPLIER);
		port.visible = false;
		add(port);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		stateChecks();

		if (CURRENT_STATE == DONE)
		{
			if (FlxG.keys.justReleased.ANY)
			{
				FlxG.camera.flash(0xFFFFFF, 2);
				FlxFlicker.flicker(pressany, 4, 0.1, false, false, flicker ->
				{
					FlxG.switchState(MainMenu.new);
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
						FlxG.camera.flash(0xFFFFFF, 4);
						CURRENT_STATE = FLASH;
					}
				});

			case FLASH:
				if (FlxG.sound.music == null)
					FlxG.sound.playMusic(FileManager.getSoundFile('music/22'), 1.0, true);
				
				pressany.y = FlxG.height - (pressany.height * 2) - (16 * 2);
				pressany.visible = true;
				titlebg.visible = true;

				FlxTimer.wait(5, () ->
				{
					CURRENT_STATE = DONE;
				});

			case DONE:
				randomBGChar(sinco, 6);
				randomBGChar(port, 4);
		}
	}

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
