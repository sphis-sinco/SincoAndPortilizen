package sap.stages.sidebit1;

import sap.cutscenes.SparrowCutscene;
import sap.title.TitleState;

class Sidebit1IntroCutscene extends SparrowCutscene
{
	override public function new()
	{
		super('sidebit1/pre-sidebit1');

		cutscene_sprite.addAnimationByPrefix('part1', 'animation piece 1', 24, false);
		cutscene_sprite.addAnimationByPrefix('part2', 'animation piece 2', 24, false);
		cutscene_sprite.addAnimationByPrefix('part3', 'animation piece 3', 24, false);
		cutscene_sprite.addAnimationByPrefix('part4', 'animation piece 4', 24, false);
	}

	override function create()
	{
		super.create();

		cutscene_sprite.playAnimation('part1');
		changeCutscenePosition(-70, 150);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

        override function cutsceneEvent(animation:String) {
                super.cutsceneEvent(animation);

                switch (animation)
			{
				case 'part1':
					cutscene_sprite.playAnimation('part2');
					changeCutscenePosition(-120, 200);
				case 'part2':
					cutscene_sprite.playAnimation('part3');
					changeCutscenePosition(-255, 30);
				case 'part3':
					cutscene_sprite.playAnimation('part4');
					changeCutscenePosition(-105, -195);
				case 'part4':
					FlxG.switchState(TitleState.new);
			}
        }
}
