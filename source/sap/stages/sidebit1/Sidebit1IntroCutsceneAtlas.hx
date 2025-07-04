package sap.stages.sidebit1;

import sap.title.TitleState;

class Sidebit1IntroCutsceneAtlas extends AtlasCutscene
{
	public static var BG:FlxSprite;

	public var DIFFICULTY:String = 'normal';

	override public function new(diff:String)
	{
		super('sidebit1-precutscene-atlas');

		DIFFICULTY = diff;
		Global.playSoundEffect('SideBit1_IntroCutscene', CUTSCENES);
	}

	override function create()
	{
		super.create();
	}

	override function cutsceneEvent(animation:String)
	{
		super.cutsceneEvent(animation);
	}

	override function cutsceneEnded(?skipped_cutscene:Bool)
	{
		super.cutsceneEnded(skipped_cutscene);
		Global.switchState(new Sidebit1(DIFFICULTY));
	}
}
