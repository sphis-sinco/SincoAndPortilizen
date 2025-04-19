import sap.stages.stage1.Stage1;
import sap.stages.stage2.Stage2;
import sap.stages.stage4.Stage4;
import sap.worldmap.Worldmap;

function worldmapSelection(character:String, selection:Int)
{
        final difficulty:String = Worldmap.CURRENT_DIFFICULTY;

	trace(character + ' level ' + selection);

	switch (character.toLowerCase())
	{
                case 'portilizen':
                        if (selection == 4) Global.switchState(new Stage4(difficulty));
                        // else if (selection == 5) Global.switchState(new Stage5(difficulty));
                case 'sinco':
                        if (selection == 1) Global.switchState(new Stage1(difficulty));
                        else if (selection == 2) Global.switchState(new Stage2(difficulty));

		default:
			trace(character + ' has no implementation');
	}
}
