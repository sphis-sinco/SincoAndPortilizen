package sap.stages.stage4;

import sap.worldmap.Worldmap;

class PostStage4Cutscene extends PanelCutscene
{
	override public function new():Void
	{
		super('post-stage4');
	}

	override function finishedCutscene():Void
	{
		super.finishedCutscene();

		Global.switchState(() -> new Worldmap('Port'));
	}
}
