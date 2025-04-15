package sap.sidebitmenu;

import sap.stages.sidebit1.*;
import sap.title.TitleState;

class SidebitSelect extends State
{
	public static var SIDEBIT_NUMBER:Int = 1;
	public static var SIDEBITS:Int = 1;

	public static var NUMBER_TEXT:SparrowSprite;

	public static var DIFFICULTY:String = 'normal';

	override function create()
	{
		var bg:FlxSprite = new FlxSprite();
		bg.loadGraphic(FileManager.getImageFile('sidebitmenu/background'));
		add(bg);
		bg.screenCenter();

		var tv:FlxAnimate = new FlxAnimate(0, 0, 'assets/images/sidebitmenu/tv');
		tv.anim.addBySymbol('animation', 'static tv', 24, true);
		tv.anim.play('animation');
		add(tv);
		tv.screenCenter();
		tv.y += tv.height;

		var side1:FlxSprite = new FlxSprite();
		side1.loadGraphic(FileManager.getImageFile('sidebitmenu/stage_side'));
		side1.screenCenter();
		side1.x += (side1.width / 1.2);
		side1.y += 35;
		add(side1);

		var side2:FlxSprite = new FlxSprite();
		side2.loadGraphic(FileManager.getImageFile('sidebitmenu/stage_side'));
		side2.flipX = true;
		side2.screenCenter();
		side2.x -= (side2.width / 1.2);
		side2.y = side1.y;
		add(side2);

		var sidebitText:FlxSprite = new FlxSprite();
		sidebitText.loadGraphic(FileManager.getImageFile('sidebitmenu/sidebit'));
		sidebitText.screenCenter();
		sidebitText.y += sidebitText.height;
		add(sidebitText);

		NUMBER_TEXT = new SparrowSprite('sidebitmenu/numbers');
		NUMBER_TEXT.addAnimationByPrefix('numbers', 'number');
		NUMBER_TEXT.animation.pause();
		NUMBER_TEXT.screenCenter();
		NUMBER_TEXT.y += NUMBER_TEXT.height * 1.4;
		NUMBER_TEXT.x += 30;
		add(NUMBER_TEXT);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		Global.playMusic('Lado', 1.0, false);

		if (FlxG.keys.justReleased.ESCAPE)
		{
			Global.switchState(new TitleState());
		}
		else if (FlxG.keys.justReleased.ENTER)
		{
			switch (SIDEBIT_NUMBER)
			{
				case 1:
					FlxG.sound.music.stop();
					Global.switchState(new Sidebit1IntroCutsceneAtlas(DIFFICULTY));
			}
		}

		if (SIDEBIT_NUMBER > SIDEBITS)
			SIDEBIT_NUMBER = SIDEBITS;

		NUMBER_TEXT.animation.frameIndex = SIDEBIT_NUMBER - 1;
	}
}
