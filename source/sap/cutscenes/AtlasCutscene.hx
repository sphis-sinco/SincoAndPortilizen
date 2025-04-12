package sap.cutscenes;

import flxanimate.FlxAnimate;
import sap.title.TitleState;

class AtlasCutscene extends State
{
	public var CUTSCENE_JSON:CutsceneJson;
	public var CUTSCENE_ATLAS:FlxAnimate;

	override public function new(cutsceneJsonPath:String)
	{
		super();

		CUTSCENE_JSON = FileManager.getJSON(FileManager.getDataFile('cutscenes/${cutsceneJsonPath}.json'));

		if (CUTSCENE_JSON.type.toLowerCase() == 'atlas')
		{
			if (CUTSCENE_JSON.assetPath == null)
				throw 'Missing cutscene json field: "assetPath"';
			if (CUTSCENE_JSON.symbol_names == null)
				throw 'Missing cutscene json field: "symbol_names"';
			if (CUTSCENE_JSON.parts == null)
				throw 'Missing cutscene json field: "parts"';
		}
		else
		{
			throw 'Cutscene json field "type" should be "sparrow"';
		}

		CUTSCENE_ATLAS = new FlxAnimate(FileManager.getImageFile('cutscenes/${CUTSCENE_JSON.assetPath}').replace('.png', ''));
		CUTSCENE_PART = 0;

		var part:Int = 1;
		for (symbol in CUTSCENE_JSON.symbol_names)
		{
			CUTSCENE_ATLAS.anim.addBySymbol('part${part}', symbol, 24, false);

			part++;
		}
	}

	override function create()
	{
		super.create();

		add(CUTSCENE_ATLAS);
		CUTSCENE_ATLAS.anim.onComplete.add(function()
		{
			{
				CUTSCENE_PART++;
				cutsceneEvent(CUTSCENE_ATLAS.animation.name);

				if (SLGame.isDebug)
				{
					#if EXCESS_TRACES
					trace('Automatic cutscene pause');
					CUTSCENE_ATLAS.animation.paused = true;
					#end
				}
			}
		});
		cutsceneEvent('part1');
	}

	final MOVEMENT_SPEED:Float = 5;

	public var CUTSCENE_PART:Int = 0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (CUTSCENE_ATLAS.animation.paused)
		{
			if (FlxG.keys.anyJustReleased([LEFT, RIGHT]))
				CUTSCENE_ATLAS.x += (FlxG.keys.justReleased.LEFT) ? -MOVEMENT_SPEED : MOVEMENT_SPEED;
			if (FlxG.keys.anyJustReleased([UP, DOWN]))
				CUTSCENE_ATLAS.y += (FlxG.keys.justReleased.UP) ? -MOVEMENT_SPEED : MOVEMENT_SPEED;

			// ! I dub this NOT, an excess trace conditional ! \\
			if (FlxG.keys.anyJustReleased([LEFT, RIGHT, UP, DOWN]))
				trace('Cutscene sprite position: ${CUTSCENE_ATLAS.getPosition()}');
		}

		if (FlxG.keys.justReleased.SPACE && SLGame.isDebug)
		{
			CUTSCENE_ATLAS.animation.paused = !CUTSCENE_ATLAS.animation.paused;
		}
	}

	public function cutsceneEvent(animation:String):Void
	{
		#if EXCESS_TRACES
		trace(animation);
		#end

		if (CUTSCENE_PART + 1 > CUTSCENE_JSON.parts)
			return;

		CUTSCENE_ATLAS.anim.play('part${CUTSCENE_PART + 1}');
	}
}
