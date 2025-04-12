package sap.stages.sidebit1;

class Sidebit1 extends State
{
	public static var DIFFICULTY:String;
	public static var DIFFICULTY_JSON:Sidebit1DifficultyJson;

	public static var SINCO:SB1Sinco;
	public static var PORTILIZEN:SB1Port;

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

		var rim_lighting:DropShadowShader = new DropShadowShader();
		rim_lighting.color = 0xFF1A1121;
		rim_lighting.setAdjustColor(-100, 0, -32, 0);
		rim_lighting.distance = 5;

		rim_lighting.angle = 90;
		rim_lighting.maskThreshold = 1;
		rim_lighting.useAltMask = false;
		// rim_lighting.loadAltMask(FileManager.getImageFile('gameplay/sidebits/sinco-sidebit1-shadermak'));

		SINCO = new SB1Sinco();
		SINCO.playAnimation('idle');
		SINCO.setPosition(FlxG.width - (64 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER), FlxG.height - SINCO.height);
		// SINCO.shader = rim_lighting;
		add(SINCO);

		// rim_lighting.loadAltMask(FileManager.getImageFile('gameplay/sidebits/port-sidebit1-shadermak'));
		PORTILIZEN = new SB1Port();
		PORTILIZEN.playAnimation('idle');
		PORTILIZEN.setPosition(64, FlxG.height - (PORTILIZEN.height / 1.3));
		rim_lighting.angle = -rim_lighting.angle;
		// PORTILIZEN.shader = rim_lighting;
		add(PORTILIZEN);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
