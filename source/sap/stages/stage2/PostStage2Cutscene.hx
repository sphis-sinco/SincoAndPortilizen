package sap.stages.stage2;

import sap.worldmap.Worldmap;

class PostStage2Cutscene extends PanelCutscene
{
	override public function new():Void
	{
		super('post-stage2');
	}

	override function finishedCutscene():Void
	{
		super.finishedCutscene();

		Global.switchState(() -> new Worldmap());
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
