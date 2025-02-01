package title;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

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

	override public function create()
	{
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
		if (CURRENT_STATE == DONE)
			return;

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

				CURRENT_STATE = DONE;

			case DONE:
				return;
		}
	}
}
