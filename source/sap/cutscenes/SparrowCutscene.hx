package sap.cutscenes;

import sap.title.TitleState;

class SparrowCutscene extends State
{
	public var CUTSCENE_SPRITE:SparrowSprite;

	public var CUTSCENE_JSON:CutsceneJson;

	override public function new(cutsceneJsonPath:String)
	{
		super();

		CUTSCENE_JSON = FileManager.getJSON(FileManager.getDataFile('cutscenes/${cutsceneJsonPath}.json'));

		if (CUTSCENE_JSON.type.toLowerCase() == 'sparrow')
		{
			if (CUTSCENE_JSON.assetPath == null)
				throw 'Missing cutscene json field: "assetPath"';
			if (CUTSCENE_JSON.symbol_names == null)
				throw 'Missing cutscene json field: "symbol_names"';
			if (CUTSCENE_JSON.offsets == null)
				throw 'Missing cutscene json field: "offsets"';
			if (CUTSCENE_JSON.parts == null)
				throw 'Missing cutscene json field: "parts"';
		}
		else
		{
			throw 'Cutscene json field "type" should be "sparrow"';
		}

		CUTSCENE_SPRITE = new SparrowSprite('cutscenes/${CUTSCENE_JSON.assetPath}');
		CUTSCENE_PART = 0;

		var part:Int = 1;
		for (symbol in CUTSCENE_JSON.symbol_names)
		{
			CUTSCENE_SPRITE.addAnimationByPrefix('part${part}', symbol, 24, false);

			part++;
		}

	}

	override function create()
	{
		super.create();

		add(CUTSCENE_SPRITE);
		CUTSCENE_SPRITE.animation.onFinish.add(animName ->
		{
			CUTSCENE_PART++;
			cutsceneEvent(animName);

			if (SLGame.isDebug)
			{
				trace('Automatic cutscene pause');
				CUTSCENE_SPRITE.animation.paused = true;
			}
		});
                cutsceneEvent('part1');
	}

	final MOVEMENT_SPEED:Float = 5;

	public var CUTSCENE_PART:Int = 0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (CUTSCENE_SPRITE.animation.paused)
		{
			if (FlxG.keys.anyJustReleased([LEFT, RIGHT]))
				CUTSCENE_SPRITE.x += (FlxG.keys.justReleased.LEFT) ? -MOVEMENT_SPEED : MOVEMENT_SPEED;
			if (FlxG.keys.anyJustReleased([UP, DOWN]))
				CUTSCENE_SPRITE.y += (FlxG.keys.justReleased.UP) ? -MOVEMENT_SPEED : MOVEMENT_SPEED;
			if (FlxG.keys.anyJustReleased([LEFT, RIGHT, UP, DOWN]))
				trace('Cutscene sprite position: ${CUTSCENE_SPRITE.getPosition()}');
		}

		if (FlxG.keys.justReleased.SPACE && SLGame.isDebug)
		{
			CUTSCENE_SPRITE.animation.paused = !CUTSCENE_SPRITE.animation.paused;
		}
	}

	public function cutsceneEvent(animation:String):Void
	{
		trace(animation);

		CUTSCENE_SPRITE.playAnimation('part${CUTSCENE_PART + 1}');
		changeCutscenePosition(CUTSCENE_JSON.offsets[CUTSCENE_PART][0], CUTSCENE_JSON.offsets[CUTSCENE_PART][1]);
	}

	public function changeCutscenePosition(X:Float, Y:Float)
	{
		trace('New cutscene position (anim: ${CUTSCENE_SPRITE.animation.name}): (${X} | ${Y})');
		CUTSCENE_SPRITE.setPosition(X, Y);
	}
}
