package cutscenes.intro;

import title.TitleState;

class IntroCutscene extends PanelCutscene
{
	override function finishedCutscene()
	{
		super.finishedCutscene();
        
		FlxG.switchState(TitleState.new);
	}

	override function panelEvents(panel:Int)
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