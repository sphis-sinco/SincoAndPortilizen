package sap.stages.sidebit2;

import sap.cutscenes.SparrowCutscene;
import sap.title.TitleState;

class Sidebit2IntroCutscene extends SparrowCutscene
{
	public var BG:BlankBG;
	public var DIFFICULTY:String = 'normal';

	override public function new(difficulty:String = 'normal')
	{
		super('sidebit2-precutscene');

		BG = new BlankBG();
		add(BG);

		DIFFICULTY = difficulty;
	}

	override function create()
	{
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	override function cutsceneEvent(animation:String)
	{
		super.cutsceneEvent(animation);

		switch (animation) {}
	}

	override function cutsceneEnded(?skipped_cutscene:Bool)
	{
		super.cutsceneEnded(skipped_cutscene);
		Global.switchState(new Sidebit2(DIFFICULTY));
	}
}
