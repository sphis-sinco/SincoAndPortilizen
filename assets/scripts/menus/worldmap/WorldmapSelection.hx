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
			switch (selection)
			{
				case 1: if (sidebitMode) Global.switchState(new sap.stages.sidebit1.Sidebit1IntroCutscene(difficulty));
				case 2: if (sidebitMode) Global.switchState(new sap.stages.sidebit2.Sidebit2IntroCutscene(difficulty));
				case 4: if (!sidebitMode) Global.switchState(new Stage4(difficulty));
				case 5: if (!sidebitMode) Global.switchState(new Stage5(difficulty));
			}
		case 'sinco':
			switch (selection)
			{
				case 1:
					if (sidebitMode) Global.switchState(new sap.stages.sidebit1.Sidebit1IntroCutscene(difficulty)); else
						Global.switchState(new Stage1(difficulty), false, "sinco", "all");
				case 2: if (!sidebitMode) Global.switchState(new Stage2(difficulty));
				case 3: if (!sidebitMode) Global.switchState(new Stage2(difficulty));
			}
		default:
			trace(character + ' has no implementation');
	}
}
