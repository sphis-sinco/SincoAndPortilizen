import sap.stages.stage1.Stage1;
import sap.stages.stage2.Stage2;
import sap.worldmap.Worldmap;

function worldmapSelection(character:String, selection:Int)
{
        final difficulty:String = Worldmap.CURRENT_DIFFICULTY;

	trace(character + ' level ' + selection);

	switch (character)
	{
                case 'sinco':
                        // The reason it's "sap.stage.stage1.Stage1" is to avoid VS Code being an annoying piece of crap.
                        if (selection == 1) Global.switchState(new Stage1(difficulty));
                        else if (selection == 2) Global.switchState(new Stage2(difficulty));

		default:
			trace(character + ' has no implementation');
	}
}
