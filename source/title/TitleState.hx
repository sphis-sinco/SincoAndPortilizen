package title;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

enum abstract TitleStates(Int) from Int to Int
{
	var INTRO = 0;
	var FLASH = 1;
	var DONE = 2;
}

class TitleState extends FlxState
{
	public var CURRENT_STATE:TitleStates = INTRO;

	var charring:FlxSprite = new FlxSprite();
	var pressany:FlxSprite = new FlxSprite();
	var titlebg:FlxSprite = new FlxSprite();

	var sinco:TitleSinco = new TitleSinco();

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

		super.create();
	}

	override public function update(elapsed:Float)
	{
		stateChecks();

		if (CURRENT_STATE == DONE) {}

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
				pressany.y = FlxG.height - (pressany.height * 2) - (16 * 2);
				pressany.visible = true;
				titlebg.visible = true;

				CURRENT_STATE = DONE;

			case DONE:
				if (FlxG.random.bool(5) && !sinco.visible)
				{
					sinco.visible = true;
					sinco.y = FlxG.height - (32 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER);
					sinco.x = -(sinco.width * 2);
					FlxTween.tween(sinco, {x: FlxG.width + (sinco.width * 2)}, 2, {
						onComplete: _tween ->
						{
							FlxTimer.wait(FlxG.random.float(1, 4), () ->
							{
								sinco.visible = false;
							});
						}
					});
				}
		}
	}
}
