package sap.stages.stage4;

class PostStage4Cutscene extends PanelCutscene
{
	override public function new():Void
	{
		super('post-stage4');
	}

	override function finishedCutscene(?cutscene_skipped:Bool):Void
	{
		super.finishedCutscene(cutscene_skipped);

		Global.switchState(new Worldmap());
	}
}
