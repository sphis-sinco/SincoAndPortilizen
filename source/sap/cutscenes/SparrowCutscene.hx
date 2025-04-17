package sap.cutscenes;

class SparrowCutscene extends State
{
	public var CUTSCENE_SPRITE:SparrowSprite;

	public var CUTSCENE_JSON:CutsceneJson;

	override public function new(cutsceneJsonPath:String)
	{
		super();

		CUTSCENE_JSON = FileManager.getJSON(FileManager.getDataFile('${cutsceneJsonPath}.json', CUTSCENES));

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

		CUTSCENE_SPRITE = new SparrowSprite('${CUTSCENE_JSON.assetPath}', CUTSCENES);
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

			if (Global.DEBUG_BUILD)
			{
				#if EXCESS_TRACES
				trace('Automatic cutscene pause');
				CUTSCENE_SPRITE.animation.paused = true;
				#end
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
			if (Global.anyKeysPressed([LEFT, RIGHT]))
				CUTSCENE_SPRITE.x += Global.keyJustReleased(LEFT) ? -MOVEMENT_SPEED : MOVEMENT_SPEED;
			if (Global.anyKeysPressed([UP, DOWN]))
				CUTSCENE_SPRITE.y += Global.keyJustReleased(UP) ? -MOVEMENT_SPEED : MOVEMENT_SPEED;

			// ! I dub this NOT, an excess trace conditional ! \\
			if (Global.anyKeysPressed([LEFT, RIGHT, UP, DOWN]))
				trace('Cutscene sprite position: ${CUTSCENE_SPRITE.getPosition()}');
		}

		if (Global.keyJustReleased(SPACE) && Global.DEBUG_BUILD)
		{
			CUTSCENE_SPRITE.animation.paused = !CUTSCENE_SPRITE.animation.paused;
		}

		if (Global.keyJustReleased(ESCAPE) && !CUTSCENE_SPRITE.animation.paused)
		{
			cutsceneEnded(true);
		}
	}

	public function cutsceneEvent(animation:String):Void
	{
		#if EXCESS_TRACES
		trace(animation);
		#end

		if (!(CUTSCENE_PART + 1 > CUTSCENE_JSON.parts))
		{
			CUTSCENE_SPRITE.playAnimation('part${CUTSCENE_PART + 1}');

			changeCutscenePosition(CUTSCENE_JSON.offsets[CUTSCENE_PART][0], CUTSCENE_JSON.offsets[CUTSCENE_PART][1]);
		}
		else
		{
			cutsceneEnded();
		}
	}

	public function changeCutscenePosition(X:Float, Y:Float)
	{
		#if EXCESS_TRACES
		trace('New cutscene position (anim: ${CUTSCENE_SPRITE.animation.name}): (${X} | ${Y})');
		#end
		CUTSCENE_SPRITE.setPosition(X, Y);
	}

	public function cutsceneEnded(?skipped_cutscene:Bool):Void {}
}
