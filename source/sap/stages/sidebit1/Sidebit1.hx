package sap.stages.sidebit1;

import sap.stages.sidebit1.SB1Port.SB1PortAIState;

class Sidebit1 extends State
{
	public static var DIFFICULTY:String;
	public static var DIFFICULTY_JSON:Sidebit1DifficultyJson;

	public static var SINCO:SB1Sinco;
	public static var SINCO_GHOST:SB1Sinco;
	public static var PORTILIZEN:SB1Port;
	public static var PORT_GHOST:SB1Port;

	public static var SINCO_POINT:FlxPoint;
	public static var PORTILIZEN_POINT:FlxPoint;

	override public function new(difficulty:String)
	{
		super();

		DIFFICULTY = difficulty;
		DIFFICULTY_JSON = {};
		trace('Sidebit 1 (${DIFFICULTY})');
	}

	public static var PORTILIZEN_ATTACK_CHANCE = 65;
	public static var PORTILIZEN_FOCUS_CHANCE = 25;

	public static var PORTILIZEN_DODGE_CHANCE_UNFOCUSED = 35;
	public static var PORTILIZEN_DODGE_CHANCE_FOCUS = 70;

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

			if (SINCO.animation.name == 'attack')
			{
				// disable these lines and keep the tween to get sinco's cool epic new technique: transtant
				enable_abilities = false;
				idle = false;
				// end of anti-transtant lines

				SINCO.setPosition(SINCO_POINT.x, SINCO_POINT.y);
				SINCO.x -= 160;

				SINCO.playAnimation('attack-loop');
				FlxTween.tween(SINCO, {x: PORTILIZEN.x - 160}, SINCO_ATTACK_SPEED, {
					onComplete: function(tween)
					{
						if (SINCO.overlaps(PORTILIZEN) && PORTILIZEN.State != ATTACK && PORTILIZEN.State != DODGE)
						{
							PORTILIZEN.State = HIT;
							PORTILIZEN.playAnimation(PORTILIZEN.State);
						}

						FlxTween.tween(SINCO, {x: SINCO_POINT.x - 160}, SINCO_ATTACK_SPEED, {
							onComplete: function(tween)
							{
								SINCO.setPosition(SINCO_POINT.x, SINCO_POINT.y);
								SINCO.x -= 14;
								SINCO.playAnimation('attack-end');
							},
							ease: FlxEase.sineOut
						});
					},
					ease: FlxEase.sineIn
				});
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
		SINCO_GHOST.alpha = 0.5;

		// add(SINCO_GHOST);
		add(SINCO);

		PORTILIZEN = new SB1Port();
		PORTILIZEN.playAnimation('idle');
		PORTILIZEN.setPosition(64, FlxG.height - (PORTILIZEN.height / 1.3));

		PORTILIZEN_POINT = new FlxPoint(0, 0);
		PORTILIZEN_POINT.set(PORTILIZEN.x, PORTILIZEN.y);

		PORT_GHOST = new SB1Port();
		PORT_GHOST.playAnimation('idle');
		PORT_GHOST.setPosition(PORTILIZEN_POINT.x, PORTILIZEN_POINT.y);
		PORT_GHOST.alpha = 0.5;

		add(PORT_GHOST);
		add(PORTILIZEN);

		PORTILIZEN.animation.onFinish.add(function(animName)
		{
			var proceed:Bool = true;

			final port_focus_bool:Bool = FlxG.random.bool(PORTILIZEN_FOCUS_CHANCE);
			final port_dodge_bool:Bool = (FlxG.random.bool(PORTILIZEN_DODGE_CHANCE_UNFOCUSED) && PORTILIZEN.State != FOCUS);
			final port_dodge_focus_bool:Bool = (FlxG.random.bool(PORTILIZEN_DODGE_CHANCE_FOCUS) && PORTILIZEN.State == FOCUS);
			final port_attack_bool:Bool = FlxG.random.bool(PORTILIZEN_ATTACK_CHANCE);

			if (animName == 'idle')
			{
				if (port_focus_bool && proceed)
				{
					PORTILIZEN.State = FOCUS;
					proceed = false;
				}

				if (SINCO.animation.name.contains('attack') && (port_dodge_bool || port_dodge_focus_bool) && proceed)
				{
					PORTILIZEN.State = DODGE;
					proceed = false;
				}

				if (port_attack_bool && proceed)
				{
					if (!SINCO.animation.name.contains('attack'))
					{
						ABILITY_CAN_ATTACK = false;
						PORTILIZEN.State = ATTACK;
					}

					proceed = false;
				}
			}
			else
			{
				if (animName == SB1PortAIState.ATTACK && !SINCO.animation.name.contains('attack'))
				{
					ABILITY_CAN_ATTACK = true;
				}

				PORTILIZEN.State = IDLE;

				if (SINCO.animation.name.contains('attack') && (port_dodge_bool || port_dodge_focus_bool))
				{
					PORTILIZEN.State = DODGE;
				}
			}

			PORTILIZEN.setPosition(PORTILIZEN_POINT.x, PORTILIZEN_POINT.y);
			switch (PORTILIZEN.State)
			{
				case ATTACK:
					PORTILIZEN.x -= 100;
					PORTILIZEN.y -= 70;
				case HIT:
					PORTILIZEN.x -= 40;
					PORTILIZEN.y += 30;
				case DODGE | IDLE | FOCUS:
					Global.pass;
			}
			PORTILIZEN.playAnimation(PORTILIZEN.State);
		});
	}

	public static var ABILITY_CAN_DODGE:Bool = true;
	public static var ABILITY_CAN_ATTACK:Bool = true;
	public static var SINCO_ATTACK_SPEED:Float = 0.25;

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
