package sap.stages.sidebit2;

import sap.cutscenes.SparrowCutscene;

class Sidebit2EndCutscene extends SparrowCutscene
{
	override public function new()
	{
		super('sidebit2-postcutscene');
		Global.playSoundEffect('SideBit2_EndingCutscene', CUTSCENES);
	}

	override function cutsceneEnded(?skipped_cutscene:Bool)
	{
		super.cutsceneEnded(skipped_cutscene);
		Global.switchState(new Worldmap('portilizen'));
	}
}
