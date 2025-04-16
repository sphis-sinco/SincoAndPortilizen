package sap.stages.stage1;

import sap.worldmap.Worldmap;

class PostStage1Cutscene extends PanelCutscene
{
	override public function new():Void
	{
		super('post-stage1');
		soundFX = new FlxSound();
	}

	override function finishedCutscene(?cutscene_skipped:Bool):Void
	{
		super.finishedCutscene(cutscene_skipped);

		Global.switchState(new Worldmap());
	}

	public var soundFX:FlxSound;

	override function panelEvents(panel:Int):Void
	{
		super.panelEvents(panel);

		soundFX.loadEmbedded(FileManager.getSoundFile('sounds/poststage1/line-${panel}', CUTSCENES));
		soundFX.play();
	}
}
