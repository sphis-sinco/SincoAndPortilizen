package sap.stages.sidebit1;

import sap.title.TitleState;

class Sidebit1PostCutsceneAtlas extends AtlasCutscene
{
	override public function new()
	{
		super('sidebit1-postcutscene-atlas');

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		add(bg);

		Global.playSoundEffect('SideBit1_EndingCutscene', CUTSCENES);
	}

	public static var bg:FlxSprite;

	override function cutsceneEvent(animation:String)
	{
		super.cutsceneEvent(animation);

		switch (animation)
		{
			case 'part1':
		}
	}

	override function cutsceneEnded(?skipped_cutscene:Bool)
	{
		super.cutsceneEnded(skipped_cutscene);
		Global.switchState(new Worldmap());
	}
}
