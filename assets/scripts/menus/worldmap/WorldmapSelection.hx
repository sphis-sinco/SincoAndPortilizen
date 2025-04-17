function worldmapSelection(character:String, selection:Int)
{
        final difficulty:String = 'normal';

	trace(character + ' level ' + selection);

	switch (character)
	{
                case 'sinco':
                        // The reason it's "sap.stage.stage1.Stage1" is to avoid VS Code being an annoying piece of crap.
                        if (selection == 1) Global.switchState(new sap.stages.stage1.Stage1(difficulty));
                        else if (selection == 2) Global.switchState(new sap.stages.stage2.Stage2(difficulty));

		default:
			trace(character + ' has no implementation');
	}
}
