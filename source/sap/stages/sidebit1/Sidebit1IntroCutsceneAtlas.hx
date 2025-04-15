package sap.stages.sidebit1;

import sap.title.TitleState;

class Sidebit1IntroCutsceneAtlas extends AtlasCutscene
{
	public static var BG:FlxSprite;

	public var DIFFICULTY:String = 'normal';

	override public function new(diff:String)
	{
		super('sidebit1-precutscene-atlas');

		BG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		add(BG);

		DIFFICULTY = diff;
	}

	override function create()
	{
		super.create();
	}

	override function cutsceneEvent(animation:String)
	{
		switch (animation)
		{
			case 'part1':
				Global.playSoundEffect('SideBit1_IntroCutscene', CUTSCENES);
			case 'part4':
				trace('bye bye');
		}

		super.cutsceneEvent(animation);
	}

	override function cutsceneEnded()
	{
		super.cutsceneEnded();
		Global.switchState(() -> new Sidebit1(DIFFICULTY));
	}
}
