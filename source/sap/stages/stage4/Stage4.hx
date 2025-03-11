package sap.stages.stage4;

import sap.results.ResultsMenu;
import sap.worldmap.Worldmap;

class Stage4 extends State
{
        public var script:HaxeScript;
        var time:Int = 0;

	override public function new()
	{
		super();

		var scriptPath:String = FileManager.getScriptFile('gameplay/Stage4');

		TryCatch.tryCatch(() ->
		{
			script = HaxeScript.create(scriptPath);
			script.loadFile(scriptPath);
			ScriptSupport.setScriptDefaultVars(script, '', '');

			var port:PortS4;
			var enemy:EnemyS4;
			var bg:FlxSprite;
			var timerText:FlxText;
                        var enemyX:Float = 0;

			port = new PortS4();
			enemy = new EnemyS4();

			bg = new FlxSprite();
			bg.loadGraphic(FileManager.getImageFile('gameplay/port stages/Stage4BG'));
			Global.scaleSprite(bg);
			bg.screenCenter();
			add(bg);

			port.screenCenter();
			port.x = FlxG.width - port.width * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER * 4;
			add(port);

			enemy.screenCenter();
			enemy.x -= enemy.width * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER;
			enemyX = enemy.x;
			add(enemy);

			port.y = Std.int(FlxG.height - port.height * StageGlobals.DISMx2);
			enemy.y = port.y;

			FlxTimer.wait(StageGlobals.STAGE4_START_TIMER, () ->
			{
				levelComplete();
			});

			timerText = new FlxText(10, 10, 0, "60", 64);
			timerText.screenCenter();
			add(timerText);

			script.setVariable('port', port);
			script.setVariable('enemy', enemy);
			script.setVariable('enemyX', enemyX);

			script.setVariable('bg', bg);

			script.setVariable('timerText', timerText);
			script.setVariable('time', time);

                        script.setVariable('levelComplete', levelComplete);
                        script.setVariable('moveToResultsMenu', moveToResultsMenu);

			script.executeFunc("preCreate");
			script.executeFunc("create");
			script.executeFunc("postCreate");
		});
	}

	function levelComplete()
	{
		Global.beatLevel(4);
		moveToResultsMenu();
	}

        function moveToResultsMenu()
                {
                        FlxG.switchState(() -> new ResultsMenu(time, StageGlobals.STAGE4_START_TIMER, () -> new Worldmap("Port"), "port"));
                }

	override function create()
	{
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
