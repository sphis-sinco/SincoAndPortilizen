package title;

import flixel.tweens.FlxEase.EaseFunction;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class TitleState extends FlxState
{
	var characterring:FlxSprite = new FlxSprite();

	override public function create()
	{
		characterring.loadGraphic(FileManager.getImageFile('titlescreen/CharacterRing'));
		characterring.scale.set(4, 4);
		characterring.screenCenter(X);
		characterring.y = -(characterring.height * 2);
		add(characterring);

		FlxTween.tween(characterring, {y: characterring.height + 16}, 1.0, {ease: FlxEase.sineOut});

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
