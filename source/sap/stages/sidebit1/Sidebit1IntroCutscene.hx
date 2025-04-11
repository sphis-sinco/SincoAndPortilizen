package sap.stages.sidebit1;

import sap.title.TitleState;

class Sidebit1IntroCutscene extends State
{
	public static var cutscene_sprite:SparrowSprite;

	override public function new()
	{
		super();

		cutscene_sprite = new SparrowSprite('cutscenes/sidebit1/pre-sidebit1');
		cutscene_sprite.addAnimationByPrefix('part1', 'animation piece 1', 24, false);
		cutscene_sprite.addAnimationByPrefix('part2', 'animation piece 2', 24, false);
		cutscene_sprite.addAnimationByPrefix('part3', 'animation piece 3', 24, false);
		cutscene_sprite.addAnimationByPrefix('part4', 'animation piece 4', 24, false);
	}

	override function create()
	{
		super.create();

		add(cutscene_sprite);
		cutscene_sprite.setPosition(-70, 150);
		cutscene_sprite.playAnimation('part1');
		cutscene_sprite.animation.onFinish.add(animName ->
		{
                        if (SLGame.isDebug)
                        {
                                trace('Automatic cutscene pause');
                                cutscene_sprite.animation.paused = true;
                        }

			switch (cutscene_sprite.animation.name)
			{
				case 'part1':
					cutscene_sprite.x -= 25;
					cutscene_sprite.y += 50;
					cutscene_sprite.playAnimation('part2');
				case 'part2':
					cutscene_sprite.x = cutscene_sprite.x;
					cutscene_sprite.y = 0;
					cutscene_sprite.playAnimation('part3');
				case 'part3':
					cutscene_sprite.setPosition(-105, -195);
					cutscene_sprite.playAnimation('part4');
				case 'part4':
					FlxG.switchState(TitleState.new);
			}
		});
	}

	final MOVEMENT_SPEED:Float = 5;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (cutscene_sprite.animation.paused)
		{
			if (FlxG.keys.anyJustReleased([LEFT, RIGHT]))
				cutscene_sprite.x += (FlxG.keys.justReleased.LEFT) ? -MOVEMENT_SPEED : MOVEMENT_SPEED;
			if (FlxG.keys.anyJustReleased([UP, DOWN]))
				cutscene_sprite.y += (FlxG.keys.justReleased.UP) ? -MOVEMENT_SPEED : MOVEMENT_SPEED;
			if (FlxG.keys.anyJustReleased([LEFT, RIGHT, UP, DOWN]))
				trace('Cutscene sprite position: ${cutscene_sprite.getPosition()}');
		}

		if (FlxG.keys.justReleased.SPACE && SLGame.isDebug)
		{
			cutscene_sprite.animation.paused = !cutscene_sprite.animation.paused;
		}
	}
}
