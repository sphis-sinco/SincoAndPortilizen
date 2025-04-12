package sap.stages.sidebit1;

class Sidebit1 extends State
{
	public static var DIFFICULTY:String;
	public static var DIFFICULTY_JSON:Sidebit1DifficultyJson;

	override public function new(difficulty:String)
	{
		super();

		DIFFICULTY = difficulty;
		DIFFICULTY_JSON = {};
		trace('Sidebit 1 (${DIFFICULTY})');
	}

	override function create()
	{
		super.create();
                
                var bg:FlxSprite = new FlxSprite().loadGraphic(FileManager.getImageFile('gameplay/sidebits/timeVoid'));
                add(bg);
                bg.screenCenter();
                Global.scaleSprite(bg);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
