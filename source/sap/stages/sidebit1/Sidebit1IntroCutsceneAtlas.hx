package sap.stages.sidebit1;

import flxanimate.*;
import sap.cutscenes.AtlasCutscene;
import sap.title.TitleState;

class Sidebit1IntroCutsceneAtlas extends AtlasCutscene
{
	override public function new()
	{
		super('sidebit1/pre-sidebit1_atlas');
	}

	override function cutsceneEvent(animation:String)
	{
		super.cutsceneEvent(animation);

		switch (animation)
		{
			case 'part4':
				FlxG.switchState(TitleState.new);
		}
	}
}
