package sap.stages.sidebit1;

import sap.title.TitleState;

class Sidebit1IntroCutsceneAtlas extends AtlasCutscene
{
	public static var bg:FlxSprite;

	override public function new()
	{
		super('sidebit1-precutscene-atlas');

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		add(bg);
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
				Global.playSoundEffect('cutscenes/SideBit1_IntroCutscene');
			case 'part4':
				trace('bye bye');
		}

		super.cutsceneEvent(animation);
	}

	override function cutsceneEnded()
	{
		super.cutsceneEnded();
		FlxG.switchState(TitleState.new);
	}
}
