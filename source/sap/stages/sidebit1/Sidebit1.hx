package sap.stages.sidebit1;

class Sidebit1 extends State
{
	public static var DIFFICULTY:String;
	public static var DIFFICULTY_JSON:Sidebit1DifficultyJson;

	public static var SINCO:SB1Sinco;
	public static var SINCO_GHOST:SB1Sinco;
	public static var PORTILIZEN:SB1Port;

	public static var SINCO_POINT:FlxPoint;

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

		SINCO = new SB1Sinco();
		SINCO.playAnimation('idle');
		SINCO.setPosition(FlxG.width - (64 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER), FlxG.height - SINCO.height);

		SINCO_POINT = new FlxPoint(0, 0);
		SINCO_POINT.set(SINCO.x, SINCO.y);

		SINCO.animation.onFinish.add(function(animName:String)
		{
			var idle:Bool = true;
			var enable_abilities:Bool = true;

			if (SINCO.animation.name.contains('attack'))
			{
                                enable_abilities = false;
				// do smth here for loopin and shit
			}

			if (enable_abilities)
			{
				enableAbilities();
			}

			if (idle)
			{
				SINCO.setPosition(SINCO_POINT.x, SINCO_POINT.y);
				SINCO.playAnimation('idle');
			}
		});

		SINCO_GHOST = new SB1Sinco();
		SINCO_GHOST.playAnimation('idle');
		SINCO_GHOST.setPosition(SINCO_POINT.x, SINCO_POINT.y);
		add(SINCO_GHOST);
		SINCO_GHOST.alpha = 0.5;

		add(SINCO);

		PORTILIZEN = new SB1Port();
		PORTILIZEN.playAnimation('idle');
		PORTILIZEN.setPosition(64, FlxG.height - (PORTILIZEN.height / 1.3));
		add(PORTILIZEN);
	}

	public static var ABILITY_CAN_DODGE:Bool = true;
	public static var ABILITY_CAN_ATTACK:Bool = true;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.SPACE && ABILITY_CAN_DODGE)
		{
			disableAbilities();
			SINCO.setPosition(SINCO_POINT.x, SINCO_POINT.y);
			SINCO.x -= 60;
			SINCO.y += 85;
			SINCO.animation.play('dodge');
		}
		else if (FlxG.keys.justReleased.LEFT && ABILITY_CAN_ATTACK)
		{
			disableAbilities();
			SINCO.setPosition(SINCO_POINT.x, SINCO_POINT.y);
			SINCO.x -= 13.5;
			SINCO.animation.play('attack');
		}
	}

	public static dynamic function disableAbilities():Void
	{
		ABILITY_CAN_ATTACK = false;
		ABILITY_CAN_DODGE = false;
	}

	public static dynamic function enableAbilities():Void
	{
		ABILITY_CAN_ATTACK = true;
		ABILITY_CAN_DODGE = true;
	}
}
