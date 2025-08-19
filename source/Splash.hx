package;

import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class Splash extends State
{
	public var splash:Spr;
	public var splashText:FlxText;

	override function create()
	{
		super.create();

		splash = new Spr(-2);
		splash.loadGraphic(Assets.getImagePath('splash'));
		splash.scaleSpr();
		splash.screenCenter();
		add(splash);

		splashText = new FlxText();
		splashText.text = 'SAP Team';
		splashText.size = 32;
		splashText.fieldWidth = FlxG.width;
		splashText.alignment = 'center';
		splashText.screenCenter(Y);
		splashText.y += splashText.height * 4;
		add(splashText);

		Global.playSoundEffect('splash');

		FlxTween.tween(splash, {alpha: 0}, 1, {
			ease: FlxEase.sineInOut,
			startDelay: 1
		});
		FlxTimer.wait(2, () ->
		{
			InitState.switchToState(new menus.LevelSelect(), 'Level Select');
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.mouse.visible = false;
	}
}
