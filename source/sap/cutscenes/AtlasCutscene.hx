package sap.cutscenes;

class AtlasCutscene extends State
{
	public var CUTSCENE_JSON:CutsceneJson;
	public var CUTSCENE_ATLAS:FlxAnimate;

	override public function new(cutsceneJsonPath:String)
	{
		super();

		CUTSCENE_JSON = FileManager.getJSON(FileManager.getDataFile('${cutsceneJsonPath}.json', CUTSCENES));

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
			throw 'Cutscene json field "type" should be "atlas"';
		}

		CUTSCENE_ATLAS = new FlxAnimate(FileManager.getImageFile('${CUTSCENE_JSON.assetPath}', CUTSCENES).replace('.png', ''));
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
				cutsceneEvent(CUTSCENE_ANIMATION_NAME);
			}
		});
		cutsceneEvent('part1');
	}

	final MOVEMENT_SPEED:Float = 5;

	public var CUTSCENE_PART:Int = 0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public var CUTSCENE_ANIMATION_NAME:String = null;

	public function cutsceneEvent(animation:String):Void
	{
		#if !EXCESS_TRACES
		trace(animation);
		#end

		CUTSCENE_ANIMATION_NAME = 'part${CUTSCENE_PART + 1}';

		if (!(CUTSCENE_PART + 1 > CUTSCENE_JSON.parts))
		{
			CUTSCENE_ATLAS.anim.play(CUTSCENE_ANIMATION_NAME);
		}
		else
		{
			#if EXCESS_TRACES
			trace('End of cutscene');
			#end

			cutsceneEnded();
		}
	}

	public function cutsceneEnded():Void {}
}
