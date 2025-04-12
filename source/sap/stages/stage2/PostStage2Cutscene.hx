package sap.stages.stage2;

import sap.worldmap.Worldmap;

class PostStage2Cutscene extends PanelCutscene
{
	override public function new():Void
	{
		super({
			max_panels: 3,
			panel_prefix: 'ps2-',
			panel_folder: 'post-stage2/',
			rpc_details: "In the post-stage 2 cutscene"
		});
	}

	override function finishedCutscene():Void
	{
		super.finishedCutscene();

		FlxG.switchState(() -> new Worldmap());
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
