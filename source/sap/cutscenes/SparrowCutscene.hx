package sap.cutscenes;

import sap.title.TitleState;

class SparrowCutscene extends State
{
	public var cutscene_sprite:SparrowSprite;

	override public function new(filePath:String)
	{
		super();

		cutscene_sprite = new SparrowSprite('cutscenes/${filePath}');
	}

	override function create()
	{
		super.create();

		add(cutscene_sprite);
		cutscene_sprite.animation.onFinish.add(animName ->
		{
			cutsceneEvent(animName);

			if (SLGame.isDebug)
			{
				trace('Automatic cutscene pause');
				cutscene_sprite.animation.paused = true;
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

	public function cutsceneEvent(animation:String):Void
	{
		trace(animation);
	}

	public function changeCutscenePosition(X:Float, Y:Float)
	{
		trace('New cutscene position (anim: ${cutscene_sprite.animation.name}): (${X} | ${Y})');
		cutscene_sprite.setPosition(X, Y);
	}
}
