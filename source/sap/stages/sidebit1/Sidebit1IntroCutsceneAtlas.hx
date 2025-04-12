package sap.stages.sidebit1;

import flxanimate.*;
import sap.title.TitleState;

class Sidebit1IntroCutsceneAtlas extends AtlasCutscene
{
	override public function new()
	{
		super('sidebit1-precutscene-atlas');
	}

	override function cutsceneEvent(animation:String)
	{
		super.cutsceneEvent(animation);

		switch (animation)
		{
                        case 'part1':
                                Global.playSoundEffect('cutscenes/SideBit1_IntroCutscene');

			case 'part4':
                                trace('bye bye');
				FlxG.switchState(TitleState.new);
		}
	}
}
