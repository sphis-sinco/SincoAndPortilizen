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
                        script.setVariable('PostStage1Cutscene', PostStage1Cutscene);

                        script.setVariable('Worldmap', Worldmap);
                        script.setVariable('FileManager', FileManager);

                        var background:SparrowSprite;
                        var track:FlxSprite;
                        var OSIN_HEALTH:Int = 10;
                        var SINCO_HEALTH:Int = 10;
                        var OSIN_MAX_HEALTH:Int = 10;
                        var SINCO_MAX_HEALTH:Int = 10;
                        var osinHealthIndicator:FlxText;
                        var sincoHealthIndicator:FlxText;

                        osinHealthIndicator = new FlxText();
                        sincoHealthIndicator = new FlxText();

                        background = new SparrowSprite('gameplay/sinco stages/StageOneBackground');
                        add(background);

                        background.addAnimationByPrefix('idle', 'actualstagebg', 24);
                        background.playAnimation('idle');

                        background.screenCenter();

                        track = new FlxSprite();
                        track.loadGraphic(FileManager.getImageFile('gameplay/sinco stages/Stage1BG'), true, 128, 128);

                        track.animation.add('animation', [0, 1], 16);
                        track.animation.play('animation');

                        Global.scaleSprite(track, 1);
                        track.screenCenter();
                        add(track);

                        osinHealthIndicator.size = 16;
                        add(osinHealthIndicator);

                        sincoHealthIndicator.size = 16;
                        add(sincoHealthIndicator);

                        var osin = new Osin();
                        var sinco = new Sinco();

                        osin.screenCenter();
                        osin.y += osin.height * 2;
                        osin.x += osin.width * 4;
                        add(osin);
                
                        sinco.screenCenter();
                        sinco.y += sinco.height * 4;
                        sinco.x -= sinco.width * 4;
                        add(sinco);

                        script.setVariable('background', background);
                        script.setVariable('track', track);
                        script.setVariable('OSIN_HEALTH', OSIN_HEALTH);
                        script.setVariable('SINCO_HEALTH', SINCO_HEALTH);
                        script.setVariable('OSIN_MAX_HEALTH', OSIN_MAX_HEALTH);
                        script.setVariable('SINCO_MAX_HEALTH', SINCO_MAX_HEALTH);
                        script.setVariable('osinHealthIndicator', osinHealthIndicator);
                        script.setVariable('sincoHealthIndicator', sincoHealthIndicator);

                        script.setVariable('osin', osin);
                        script.setVariable('sinco', sinco);

                        var sincoPos:FlxPoint;
                        var osinPos:FlxPoint;

                        sincoPos = new FlxPoint(0, 0);
                        sincoPos.set(sinco.x, sinco.y);

                        osinPos = new FlxPoint(0, 0);
                        osinPos.set(osin.x, osin.y);

                        script.setVariable('osinPos', osinPos);
                        script.setVariable('sincoPos', sincoPos);

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
