package cutscenes.intro;

import stages.stage1.Stage1;
import title.TitleState;

class IntroCutscene extends PanelCutscene
{
	override public function new()
	{
		super({
			max_panels: 5,
			panel_prefix: 'intro-',
			panel_folder: 'intro/'
		});
	}

	override function finishedCutscene()
	{
		super.finishedCutscene();
        
		FlxG.switchState(Stage1.new);
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