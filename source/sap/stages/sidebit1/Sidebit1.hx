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

		SINCO = new SB1Sinco();
		SINCO.playAnimation('idle');
		SINCO.setPosition(FlxG.width - (64 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER), FlxG.height - SINCO.height);
		add(SINCO);
		SINCO.animation.onFinish.add(function(animName:String)
		{
			if (SINCO.animation.name == 'dodge')
			{
				ABILITY_CAN_ATTACK = true;
			}
			else if (SINCO.animation.name.contains('attack'))
			{
				ABILITY_CAN_DODGE = true;
			} else {
                                SINCO.playAnimation('idle');
                        }
		});

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
			ABILITY_CAN_ATTACK = false;
			SINCO.animation.play('dodge');
		}
		else if (FlxG.keys.justReleased.LEFT && ABILITY_CAN_ATTACK)
		{
			ABILITY_CAN_DODGE = false;
			SINCO.animation.play('attack');
		}
	}
}
