package sap.cutscenes.intro;

import sap.worldmap.Worldmap;

class IntroCutscene extends PanelCutscene
{
	override public function new():Void
	{
		super('intro');
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
			// gonna put voiceover stuff here
			case 1, 2, 3, 4, 5:
				Global.pass();
		}
	}
}
