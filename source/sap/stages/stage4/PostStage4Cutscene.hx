package sap.stages.stage2;

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

		FlxG.switchState(() -> new Worldmap());
	}
}
