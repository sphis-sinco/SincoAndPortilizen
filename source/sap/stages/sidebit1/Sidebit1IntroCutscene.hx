package sap.stages.sidebit1;

import sap.cutscenes.SparrowCutscene;
import sap.title.TitleState;

class Sidebit1IntroCutscene extends SparrowCutscene
{
	override public function new()
	{
		super('sidebit1-precutscene');
	}

	override function create()
	{
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

        override function cutsceneEvent(animation:String) {
                super.cutsceneEvent(animation);

                switch (animation)
			{
				case 'part4':
					FlxG.switchState(TitleState.new);
			}
        }
}
