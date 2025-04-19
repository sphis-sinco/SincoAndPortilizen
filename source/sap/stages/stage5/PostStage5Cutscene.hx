package sap.stages.stage5;

class PostStage5Cutscene extends PanelCutscene
{
	override public function new():Void
	{
		super('post-stage5');
	}

	override function finishedCutscene(?cutscene_skipped:Bool):Void
	{
		super.finishedCutscene(cutscene_skipped);

		Global.switchState(new Worldmap());
	}
}
