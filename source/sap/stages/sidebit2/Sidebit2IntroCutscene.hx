package sap.stages.sidebit2;

import sap.cutscenes.SparrowCutscene;
import sap.title.TitleState;

class Sidebit2IntroCutscene extends SparrowCutscene
{
	public var DIFFICULTY:String = 'normal';

	override public function new(difficulty:String = 'normal')
	{
		super('sidebit2-precutscene');

		DIFFICULTY = difficulty;
		Global.playSoundEffect('SideBit2_IntroCutscene', CUTSCENES);
	}

	override function cutsceneEnded(?skipped_cutscene:Bool)
	{
		super.cutsceneEnded(skipped_cutscene);
		Global.switchState(new Sidebit2(DIFFICULTY));
	}
}
