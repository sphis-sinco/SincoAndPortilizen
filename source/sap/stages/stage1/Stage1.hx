package sap.stages.stage1;

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
                        
                        script.setVariable('PostStage1Cutscene', PostStage1Cutscene);

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
                
                var tutorial1:FlxSprite = new FlxSprite();
                tutorial1.loadGraphic(FileManager.getImageFile('gameplay/tutorials/Right-Dodge'));
                tutorial1.screenCenter();
                tutorial1.y -= tutorial1.height;
                add(tutorial1);

                var tutorial2:FlxSprite = new FlxSprite();
                tutorial2.loadGraphic(FileManager.getImageFile('gameplay/tutorials/Space-Attack'));
                tutorial2.screenCenter();
                tutorial2.y += tutorial2.height;
                add(tutorial2);

                FlxTimer.wait(1, () -> {
                        FlxTween.tween(tutorial1, {alpha: 0}, 1);
                        FlxTween.tween(tutorial2, {alpha: 0}, 1);
                });

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
