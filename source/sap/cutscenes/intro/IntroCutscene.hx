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
                        case 2:
                                Global.playSoundEffect('tirok', CUTSCENES);

			// gonna put voiceover stuff here
			case 1, 3, 4, 5:
				Global.pass();
		}
	}
}
