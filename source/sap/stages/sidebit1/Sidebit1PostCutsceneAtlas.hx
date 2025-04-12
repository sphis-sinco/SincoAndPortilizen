package sap.stages.sidebit1;

import sap.title.TitleState;

class Sidebit1PostCutsceneAtlas extends AtlasCutscene
{
	override public function new()
	{
		super('sidebit1/post-sidebit1_atlas');

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
                add(bg);
	}

	public static var bg:FlxSprite;

	override function cutsceneEvent(animation:String)
	{
		super.cutsceneEvent(animation);

		switch (animation)
		{
			case 'part5':
				FlxG.switchState(TitleState.new);
		}
	}
}
