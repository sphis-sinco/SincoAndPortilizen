package sap.stages.stage1;

import sap.results.ResultsMenu;
import sap.worldmap.Worldmap;

class Stage1 extends State
{
	public var script:HaxeScript;

	override public function new()
	{
		super();

		var scriptPath:String = FileManager.getScriptFile('gameplay/Stage1');

		TryCatch.tryCatch(() ->
		{
			script = HaxeScript.create(scriptPath);
			script.loadFile(scriptPath);
			ScriptSupport.setScriptDefaultVars(script, '', '');

                        script.setVariable('FlxPoint', new FlxPoint());
                        script.setVariable('SparrowSprite', SparrowSprite);
                        script.setVariable('ResultsMenu', ResultsMenu);
                        script.setVariable('StageGlobals', StageGlobals);
                        script.setVariable('Osin', Osin);
                        script.setVariable('PostStage1Cutscene', PostStage1Cutscene);
                        script.setVariable('Sinco', Sinco);
                        script.setVariable('Worldmap', Worldmap);
                        script.setVariable('FileManager', FileManager);

			script.executeFunc("preCreate");
			script.executeFunc("create");
			script.executeFunc("postCreate");
		});
	}
        
        override function create() {
                super.create();
        }

	override function update(elapsed:Float)
	{
		TryCatch.tryCatch(() ->
		{
			if (script != null)
				script.executeFunc("update", [elapsed]);
		});

		super.update(elapsed);
	}
}
