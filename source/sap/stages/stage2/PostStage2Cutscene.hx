package sap.stages.stage2;

class PostStage2Cutscene extends PanelCutscene
{
	override public function new():Void
	{
		super('post-stage2');
	}

	override function finishedCutscene(?cutscene_skipped:Bool):Void
	{
		super.finishedCutscene(cutscene_skipped);

		Global.switchState(new Worldmap());
	}

	override function panelEvents(panel:Int):Void
	{
		super.panelEvents(panel);

		switch (panel)
		{
			// gonna put voiceover stuff here prob
			case 2:
				Global.pass();
		}
	}
}
