package sap.stages.stage5;

class PostStage5Cutscene extends PanelCutscene
{
	override public function new():Void
	{
		super('post-stage5');
		soundFX = new FlxSound();
	}

	public var soundFX:FlxSound;

	override function panelEvents(panel:Int)
	{
		super.panelEvents(panel);

		if (panel == 1)
			Global.playSoundEffect('gameplay/attack-failed');

		soundFX.loadEmbedded(FileManager.getSoundFile('sounds/poststage5/line-${panel}', CUTSCENES));
		soundFX.play();
	}

	override function finishedCutscene(?cutscene_skipped:Bool):Void
	{
		super.finishedCutscene(cutscene_skipped);

		Global.switchState(new Worldmap());
	}
}
