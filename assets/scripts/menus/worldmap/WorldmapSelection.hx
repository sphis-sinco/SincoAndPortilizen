import sap.stages.sidebit1.Sidebit1IntroCutsceneAtlas;
import sap.stages.stage1.Stage1;
import sap.stages.stage2.Stage2;
import sap.stages.stage4.Stage4;
import sap.stages.stage5.Stage5;
import sap.worldmap.Worldmap;

function worldmapSelection(character:String, selection:Int, sidebitMode:Bool)
{
	final difficulty:String = Worldmap.CURRENT_DIFFICULTY;

	trace(character + ' ' + ((sidebitMode) ? 'sidebit' : 'level') + ' ' + selection);

	switch (character.toLowerCase())
	{
		case 'portilizen':
			if (selection == 4 && !sidebitMode)
				Global.switchState(new Stage4(difficulty));
			else if (selection == 1 && sidebitMode)
				Global.switchState(new Sidebit1IntroCutsceneAtlas(difficulty));
			else if (selection == 5 && !sidebitMode)
				Global.switchState(new Stage5(difficulty));
		case 'sinco':
			if (selection == 1 && !sidebitMode)
				Global.switchState(new Stage1(difficulty));
			else if (selection == 1 && sidebitMode)
				Global.switchState(new Sidebit1IntroCutsceneAtlas(difficulty));
			else if (selection == 2 && !sidebitMode)
				Global.switchState(new Stage2(difficulty));

		default:
			trace(character + ' has no implementation');
	}
}
