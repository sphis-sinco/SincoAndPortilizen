package sap.stages.sidebit1;

import sap.stages.sidebit1.SB1Port.SB1PortAIState;

class Sidebit1 extends PausableState
{
	public static var DIFFICULTY:String;
	public static var DIFFICULTY_JSON:Sidebit1DifficultyJson;

	public static var SINCO:SB1Sinco;
	public static var SINCO_GHOST:SB1Sinco;
	public static var PORTILIZEN:SB1Port;
	public static var PORT_GHOST:SB1Port;

	public static var SINCO_POINT:FlxPoint;
	public static var PORTILIZEN_POINT:FlxPoint;

	public static var INFO_TEXTFIELD:FlxText;
	public static var INFO_TEXT:String;

	public static var PROGRESS_BAR:FlxBar;

	public static var SINCO_HEALTH:Float = 10;
	public static var PORTILIZEN_HEALTH:Float = 10;

	public static var SINCO_MAX_HEALTH:Float = 10;
	public static var PORTILIZEN_MAX_HEALTH:Float = 10;

	public static var CAN_DECREASE_SINCO_HEALTH:Bool = true;
	public static var CAN_DECREASE_PORTILIZEN_HEALTH:Bool = true;

	public static var RUNNING:Bool = false;

	override public function new(difficulty:String)
	{
		super(false);

		DIFFICULTY = difficulty;
		DIFFICULTY_JSON = FileManager.getJSON(FileManager.getDataFile('stages/sidebit1/${difficulty}.json'));

		SINCO_MAX_HEALTH = DIFFICULTY_JSON.player_max_health;
		PORTILIZEN_MAX_HEALTH = DIFFICULTY_JSON.opponent_max_health;

		SINCO_HEALTH = SINCO_MAX_HEALTH;
		PORTILIZEN_HEALTH = PORTILIZEN_MAX_HEALTH;

		SINCO_ATTACK_SPEED = DIFFICULTY_JSON.player_attack_speed;

		PORTILIZEN_ATTACK_CHANCE = DIFFICULTY_JSON.opponent_attack_chance;
		PORTILIZEN_FOCUS_CHANCE = DIFFICULTY_JSON.opponent_focus_chance;
		PORTILIZEN_DODGE_CHANCE_UNFOCUSED = DIFFICULTY_JSON.opponent_dodge_chance_unfocused;
		PORTILIZEN_DODGE_CHANCE_FOCUS = DIFFICULTY_JSON.opponent_dodge_chance_focused;

		trace('Sidebit 1 (${DIFFICULTY})');
	}

	public static var PORTILIZEN_ATTACK_CHANCE:Float = 65;
	public static var PORTILIZEN_FOCUS_CHANCE:Float = 25;

	public static var PORTILIZEN_DODGE_CHANCE_UNFOCUSED:Float = 35;
	public static var PORTILIZEN_DODGE_CHANCE_FOCUS:Float = 70;

	public static var TUTORIAL_SHADER:AdjustColorShader;

	public static var PLAYER_HEALTH_ICON:HealthIcon;
	public static var OPPONENT_HEALTH_ICON:HealthIcon;

	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().loadGraphic(FileManager.getImageFile('gameplay/timeVoid'));
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
                                Global.playSoundEffect('gameplay/attack');
				FlxTween.tween(SINCO, {x: PORTILIZEN.x - 160}, SINCO_ATTACK_SPEED, {
					onComplete: function(tween)
					{
						if (SINCO.overlaps(PORTILIZEN)
							&& (PORTILIZEN.State != ATTACK || PORTILIZEN.State != ATTACK_PREP)
							&& PORTILIZEN.State != DODGE)
						{
							PORTILIZEN.State = HIT;
							Global.hitHurt();
							PORTILIZEN.setPosition(PORTILIZEN_POINT.x, PORTILIZEN_POINT.y);
							PORTILIZEN.x -= 40;
							PORTILIZEN.y += 30;
							PORTILIZEN.playAnimation(PORTILIZEN.State);
							if (CAN_DECREASE_PORTILIZEN_HEALTH)
							{
								PORTILIZEN_HEALTH--;
								CAN_DECREASE_PORTILIZEN_HEALTH = false;
							}
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

			if (!CAN_DECREASE_PORTILIZEN_HEALTH)
			{
				CAN_DECREASE_PORTILIZEN_HEALTH = true;
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
		PORTILIZEN.setPosition(64, FlxG.height - 250);

		PORTILIZEN_POINT = new FlxPoint(0, 0);
		PORTILIZEN_POINT.set(PORTILIZEN.x, PORTILIZEN.y);

		PORT_GHOST = new SB1Port();
		PORT_GHOST.playAnimation('attack');
		PORT_GHOST.setPosition(PORTILIZEN_POINT.x, PORTILIZEN_POINT.y);
		PORT_GHOST.alpha = 0.5;
		PORT_GHOST.x -= 100;
		PORT_GHOST.y -= 70;

		// add(PORT_GHOST);
		add(PORTILIZEN);

		PORTILIZEN.animation.onFinish.add(function(animName)
		{
			var proceed:Bool = true;

			final port_focus_bool:Bool = FlxG.random.bool(PORTILIZEN_FOCUS_CHANCE);
			final port_dodge_bool:Bool = (FlxG.random.bool(PORTILIZEN_DODGE_CHANCE_UNFOCUSED) && PORTILIZEN.State != FOCUS);
			final port_dodge_focus_bool:Bool = (FlxG.random.bool(PORTILIZEN_DODGE_CHANCE_FOCUS) && PORTILIZEN.State == FOCUS);
			final port_attack_bool:Bool = FlxG.random.bool(PORTILIZEN_ATTACK_CHANCE);

			#if EXCESS_TRACES
			if (animName == 'attack')
				trace('Port anim frame index: ${PORTILIZEN.animation.frameIndex}');
			#end

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
						PORTILIZEN.State = ATTACK_PREP;
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
				if (animName == SB1PortAIState.ATTACK && SINCO.animation.name == 'hit')
				{
					enableAbilities();
				}

				PORTILIZEN.State = IDLE;

				if (SINCO.animation.name.contains('attack') && (port_dodge_bool || port_dodge_focus_bool))
				{
					PORTILIZEN.State = DODGE;
				}

				if (animName == SB1PortAIState.ATTACK_PREP)
				{
					PORTILIZEN.State = ATTACK;
				}
			}

			PORTILIZEN.setPosition(PORTILIZEN_POINT.x, PORTILIZEN_POINT.y);
			switch (PORTILIZEN.State)
			{
				case ATTACK:
					PORTILIZEN.x -= 100;
					PORTILIZEN.y -= 70;
				case ATTACK_PREP:
					PORTILIZEN.x -= 100 + 10.5;
					PORTILIZEN.y -= 70 - 35;
				case HIT:
					PORTILIZEN.x -= 40;
					PORTILIZEN.y += 30;
				case DODGE | IDLE | FOCUS:
					Global.pass;
			}

			if (!CAN_DECREASE_SINCO_HEALTH)
			{
				CAN_DECREASE_SINCO_HEALTH = true;
			}

			PORTILIZEN.playAnimation(PORTILIZEN.State);
		});

		PROGRESS_BAR = new FlxBar(0, 0, RIGHT_TO_LEFT, Std.int(FlxG.width / 2), 16, this, 'health', 0, 100, true);
		add(PROGRESS_BAR);
		PROGRESS_BAR.screenCenter(X);
		PROGRESS_BAR.y = FlxG.height - PROGRESS_BAR.height - 64;
		PROGRESS_BAR.createFilledBar(Random.dominantColor(SINCO), Random.dominantColor(PORTILIZEN), true, FlxColor.BLACK, 4);

		INFO_TEXTFIELD = new FlxText(PROGRESS_BAR.x, PROGRESS_BAR.y + 16, 0, INFO_TEXT, 16);

		PLAYER_HEALTH_ICON = new HealthIcon('gameplay/sidebits/sinco-healthicon', 'Sinco');
		PLAYER_HEALTH_ICON.flipX = true;
		OPPONENT_HEALTH_ICON = new HealthIcon('gameplay/sidebits/port-healthicon', 'Portilizen');
		OPPONENT_HEALTH_ICON.flipX = true;
		add(PLAYER_HEALTH_ICON);
		add(OPPONENT_HEALTH_ICON);

		add(INFO_TEXTFIELD);

		TUTORIAL_SHADER = new AdjustColorShader();
		TUTORIAL_SHADER.brightness = -50;

		var tutorial1:FlxSprite = new FlxSprite();
		tutorial1.loadGraphic(FileManager.getImageFile('gameplay/tutorials/non-pixel/Space-Dodge'));
		tutorial1.screenCenter();
		tutorial1.y -= tutorial1.height;
		add(tutorial1);

		var tutorial2:FlxSprite = new FlxSprite();
		tutorial2.loadGraphic(FileManager.getImageFile('gameplay/tutorials/non-pixel/Left-Attack'));
		tutorial2.screenCenter();
		tutorial2.y += tutorial2.height;
		add(tutorial2);

		tutorial1.shader = TUTORIAL_SHADER;
		tutorial2.shader = TUTORIAL_SHADER;

		FlxTimer.wait(3, () ->
		{
			FlxTween.tween(tutorial1, {alpha: 0}, 1);
			FlxTween.tween(tutorial2, {alpha: 0}, 1);
		});
		RUNNING = true;
	}

	public static var ABILITY_CAN_DODGE:Bool = true;
	public static var ABILITY_CAN_ATTACK:Bool = true;
	public static var SINCO_ATTACK_SPEED:Float = 0.25;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.watch.addQuick('port frame index', PORTILIZEN.animation.frameIndex);

		if (Global.keyJustReleased(ESCAPE) && SINCO_HEALTH >= 1 && PORTILIZEN_HEALTH >= 1)
		{
			togglePaused();
		}

		PORTILIZEN.animation.paused = paused;
		SINCO.animation.paused = paused;

		updateHealthIndicators();

		if (Global.keyJustReleased(SPACE) && ABILITY_CAN_DODGE && !paused)
		{
			disableAbilities();
			SINCO.setPosition(SINCO_POINT.x, SINCO_POINT.y);
			SINCO.x -= 60;
			SINCO.y += 85;
			SINCO.animation.play('dodge');
		}
		else if (Global.keyJustReleased(LEFT) && ABILITY_CAN_ATTACK && !paused)
		{
			disableAbilities();
			SINCO.setPosition(SINCO_POINT.x, SINCO_POINT.y);
			SINCO.x -= 13.5;
			SINCO.animation.play('attack');
		}

		if (Global.keyJustReleased(R) && !paused)
		{
			Global.switchState(new Sidebit1(DIFFICULTY));
			FlxG.camera.flash(FlxColor.WHITE, .25, null, true);
		}

		if (PORTILIZEN.animation.frameIndex > 10 && PORTILIZEN.animation.frameIndex < 19 && !paused)
		{
			if (PORTILIZEN.State != ATTACK)
				return;
			if (SINCO.animation.name == 'dodge')
				return;

			FlxTween.cancelTweensOf(SINCO);
			disableAbilities();
			SINCO.setPosition(SINCO_POINT.x, SINCO_POINT.y);
			SINCO.x -= 25;
			SINCO.y += 100;
			if (SINCO.animation.name != 'hit') Global.hitHurt();
			SINCO.playAnimation('hit');
			if (CAN_DECREASE_SINCO_HEALTH)
			{
				CAN_DECREASE_SINCO_HEALTH = false;
				SINCO_HEALTH--;
			}
		}

		Worldmap.SIDEBIT_MODE = true;
		if (PORTILIZEN_HEALTH == 0)
			Global.switchState(new ResultsMenu(Std.int(SINCO_HEALTH), Std.int(SINCO_MAX_HEALTH), new Sidebit1PostCutsceneAtlas()));
		else if (SINCO_HEALTH == 0)
			Global.switchState(new ResultsMenu(Std.int(PORTILIZEN_MAX_HEALTH - PORTILIZEN_HEALTH), Std.int(PORTILIZEN_MAX_HEALTH), new Worldmap()));
	}

	public static function updateHealthIndicators():Void
	{
		INFO_TEXT = 'Sinco: ${Global.getLocalizedPhrase('HP')}: $SINCO_HEALTH/$SINCO_MAX_HEALTH || Portilizen: ${Global.getLocalizedPhrase('HP')}: $PORTILIZEN_HEALTH/$PORTILIZEN_MAX_HEALTH';
		PROGRESS_BAR.percent = (PORTILIZEN_HEALTH / PORTILIZEN_MAX_HEALTH) * 100;
		INFO_TEXTFIELD.text = INFO_TEXT;
		INFO_TEXTFIELD.screenCenter(X);

		var percent:Float = MAXIMUM_PERCENT - PROGRESS_BAR.percent;

		if (percent < 0)
			percent = 0;

		PLAYER_HEALTH_ICON.x = PROGRESS_BAR.x + ((percent * PROGRESS_BAR.pxPerPercent) - 32);
		OPPONENT_HEALTH_ICON.x = PLAYER_HEALTH_ICON.x + POSITION_OFFSET;

		PLAYER_HEALTH_ICON.y = PROGRESS_BAR.getGraphicMidpoint().y - 48;
		OPPONENT_HEALTH_ICON.y = PLAYER_HEALTH_ICON.y - 4;

		if (OPPONENT_HEALTH_ICON.animation.name.toLowerCase().contains('loss'))
		{
			OPPONENT_HEALTH_ICON.y = PLAYER_HEALTH_ICON.y + 4;
		}

		if (PORTILIZEN_HEALTH < WINNING_THRESHOLD)
		{
			if (PLAYER_HEALTH_ICON.animation.name == 'neutral' && PLAYER_HEALTH_ICON.animation.finished)
				PLAYER_HEALTH_ICON.playAnimation('toWin');
			else if (PLAYER_HEALTH_ICON.animation.name == 'toWin' && PLAYER_HEALTH_ICON.animation.finished)
				PLAYER_HEALTH_ICON.playAnimation('win');

			if (OPPONENT_HEALTH_ICON.animation.name == 'neutral' && OPPONENT_HEALTH_ICON.animation.finished)
				OPPONENT_HEALTH_ICON.playAnimation('toLoss');
			else if (OPPONENT_HEALTH_ICON.animation.name == 'toLoss' && OPPONENT_HEALTH_ICON.animation.finished)
				OPPONENT_HEALTH_ICON.playAnimation('loss');
		}
		else if (PORTILIZEN_HEALTH > LOSING_THRESHOLD)
		{
			if (OPPONENT_HEALTH_ICON.animation.name == 'neutral' && OPPONENT_HEALTH_ICON.animation.finished)
				OPPONENT_HEALTH_ICON.playAnimation('toWin');
			else if (OPPONENT_HEALTH_ICON.animation.name == 'toWin' && OPPONENT_HEALTH_ICON.animation.finished)
				OPPONENT_HEALTH_ICON.playAnimation('win');

			if (PLAYER_HEALTH_ICON.animation.name == 'neutral' && PLAYER_HEALTH_ICON.animation.finished)
				PLAYER_HEALTH_ICON.playAnimation('toLoss');
			else if (PLAYER_HEALTH_ICON.animation.name == 'toLoss' && PLAYER_HEALTH_ICON.animation.finished)
				PLAYER_HEALTH_ICON.playAnimation('loss');
		}
		else
		{
			if (OPPONENT_HEALTH_ICON.animation.name == 'win' && OPPONENT_HEALTH_ICON.animation.finished)
				OPPONENT_HEALTH_ICON.playAnimation('toWin', false, true);
			else if (OPPONENT_HEALTH_ICON.animation.name == 'loss' && OPPONENT_HEALTH_ICON.animation.finished)
				OPPONENT_HEALTH_ICON.playAnimation('toLoss', false, true);
			else
				OPPONENT_HEALTH_ICON.playAnimation('neutral');

			if (PLAYER_HEALTH_ICON.animation.name == 'win' && PLAYER_HEALTH_ICON.animation.finished)
				PLAYER_HEALTH_ICON.playAnimation('toWin', false, true);
			else if (PLAYER_HEALTH_ICON.animation.name == 'loss' && PLAYER_HEALTH_ICON.animation.finished)
				PLAYER_HEALTH_ICON.playAnimation('toLoss', false, true);
			else
				PLAYER_HEALTH_ICON.playAnimation('neutral');
		}
	}

	// These control health icon shit
	static final MAXIMUM_PERCENT:Float = 100;
	static final WINNING_THRESHOLD:Int = 3;
	static final LOSING_THRESHOLD:Int = 7;
	static final POSITION_OFFSET:Int = 64;

	public static function disableAbilities():Void
	{
		ABILITY_CAN_ATTACK = false;
		ABILITY_CAN_DODGE = false;
	}

	public static function enableAbilities():Void
	{
		ABILITY_CAN_ATTACK = true;
		ABILITY_CAN_DODGE = true;
	}
}
