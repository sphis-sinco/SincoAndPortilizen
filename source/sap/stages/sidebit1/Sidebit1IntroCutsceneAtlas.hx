package sap.stages.sidebit1;

import flxanimate.*;
import sap.title.TitleState;

class Sidebit1IntroCutsceneAtlas extends State
{
        public var CUTSCENE_ATLAS:FlxAnimate;

	override public function new()
	{
		super();

                CUTSCENE_ATLAS = new FlxAnimate(FileManager.getImageFile('cutscenes/sidebit1/pre-sidebit1_atlas').replace('.png', ''));
                CUTSCENE_ATLAS.anim.addBySymbol('part1', 'animation piece 1', 0, 0, 24);
                CUTSCENE_ATLAS.anim.addBySymbol('part2', 'animation piece 2', 0, 0, 24);
                CUTSCENE_ATLAS.anim.addBySymbol('part3', 'animation piece 3', 0, 0, 24);
                CUTSCENE_ATLAS.anim.addBySymbol('part4', 'animation piece 4', 0, 0, 24);

	}

	override function create()
	{
		super.create();

                CUTSCENE_ATLAS.anim.play('part1');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
