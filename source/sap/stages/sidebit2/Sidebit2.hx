package sap.stages.sidebit2;

class Sidebit2 extends PausableState
{
	public static var DIFFICULTY:String = 'normal';
	public static var DIFFICULTY_JSON:Sidebit2DifficultyJson;

	public static var OP_ATK_CHANCE:Float = 45;
	public static var OP_ATK_TICK:Int = 500;
	public static var OP_ATK_TICK_RAND_MIN:Int = 200;
	public static var OP_ATK_TICK_RAND_MAX:Int = 500;

	public static var OP_DEF_CHANCE:Float = 25;
	public static var OP_DEF_CHANCE_DIDNT_HIT:Float = 40;
	public static var OP_DEF_CHANCE_DID_HIT:Float = 10;

	public static var OP_TICK:Int = 0;

	public static var PLAYER_CAN_DO_THINGS_TICK:Int = 100;
	public static var PLAYER_TICK:Int = 0;

	override public function new(difficulty:String = 'normal')
	{
		super(false);

		artEnabled = [true, true];
		artStrings = ['Sidebit2-portilizen', 'Sidebit2-osin'];

		DIFFICULTY = difficulty;
		DIFFICULTY_JSON = FileManager.getJSON(FileManager.getDataFile('stages/sidebit2/${difficulty}.json'));

		OP_ATK_CHANCE = DIFFICULTY_JSON.op_attack_chance;

		OP_ATK_TICK = DIFFICULTY_JSON.op_atk_tick;
		OP_ATK_TICK_RAND_MIN = DIFFICULTY_JSON.op_atk_tick_random_min;
		OP_ATK_TICK_RAND_MAX = DIFFICULTY_JSON.op_atk_tick_random_max;

		OP_DEF_CHANCE = DIFFICULTY_JSON.op_def_chance;
		OP_DEF_CHANCE_DIDNT_HIT = DIFFICULTY_JSON.op_def_chance_didnt_hit;
		OP_DEF_CHANCE_DID_HIT = DIFFICULTY_JSON.op_def_chance_did_hit;

		PLAYER_CAN_DO_THINGS_TICK = DIFFICULTY_JSON.player_can_do_things_tick;

		PROGRESS_BAR_GROUP = new ProgressBarGroup({
			player: 'Portilizen',
			player_health: DIFFICULTY_JSON.player_max_health,
			player_max_health: DIFFICULTY_JSON.player_max_health,
			player_healthIcon: new HealthIcon('gameplay/sidebits/port-healthicon', 'Portilizen'),

			opponent: 'Osin',
			opponent_health: DIFFICULTY_JSON.opponent_max_health,
			opponent_max_health: DIFFICULTY_JSON.opponent_max_health,
			opponent_healthIcon: new HealthIcon('gameplay/sidebits/osin-healthicon', 'OsinScaledDown'),
		});
	}

	public static var PLAYER:Sidebit2Character;
	public static var OPPONENT:Sidebit2Character;

	public static var PLAYER_POINT:FlxPoint;
	public static var OPPONENT_POINT:FlxPoint;

	public static var TUTORIAL_SHADER:AdjustColorShader;

	public static var PROGRESS_BAR_GROUP:ProgressBarGroup;

	var sparrowBG = new SparrowSprite('gameplay/sidebits/sidebit2_bg');

	override function create()
	{
		super.create();

		sparrowBG.addAnimationByPrefix('bg tilted', 'bg tilted', 24);
		sparrowBG.animation.play('bg tilted');

		sparrowBG.screenCenter();
		add(sparrowBG);

		PLAYER = new Sidebit2Character('port');
		OPPONENT = new Sidebit2Character('osin');

		OPPONENT.addAnimationByPrefix('wind-up', 'osin wind-up', 24, false);
		OPPONENT.playAnimation('idle');

		PLAYER_POINT = new FlxPoint(0, 0);
		PLAYER_POINT.set(-200, 250);

		OPPONENT_POINT = new FlxPoint(0, 0);
		OPPONENT_POINT.set(250, 128);

		add(OPPONENT);
		add(PLAYER);

		OPPONENT.animation.onFinish.add(animName ->
		{
			switch (animName)
			{
				case 'wind-up':
					OPPONENT.playAnimation('punch');
					OP_DEF_CHANCE = OP_DEF_CHANCE_DIDNT_HIT;
					if (PLAYER.animation.name != 'block')
					{
						Global.playSoundEffect('gameplay/attack-failed');
						PLAYER.playAnimation('hit');
						PROGRESS_BAR_GROUP.PLAYER_HEALTH -= 1;
						OP_DEF_CHANCE = OP_DEF_CHANCE_DID_HIT;
					}

				default:
					OPPONENT.playAnimation('idle');
			}

			opponentAnimationPosition();
		});

		PLAYER.animation.onFinish.add(animName ->
		{
			switch (animName)
			{
				case 'block':
					// do nothing for holding

				default:
					PLAYER.playAnimation('idle');
			}

			playerAnimationPosition();
		});

		add(PROGRESS_BAR_GROUP);

		TUTORIAL_SHADER = new AdjustColorShader();
		TUTORIAL_SHADER.brightness = -50;

		var tutorial1:FlxSprite = new FlxSprite();
		tutorial1.loadGraphic(FileManager.getImageFile('gameplay/tutorials/non-pixel/Left-Dodge'));
		tutorial1.screenCenter();
		tutorial1.y -= tutorial1.height;
		add(tutorial1);

		var tutorial2:FlxSprite = new FlxSprite();
		tutorial2.loadGraphic(FileManager.getImageFile('gameplay/tutorials/non-pixel/Space-Attack'));
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
	}

	public static var keys:{attack:FlxKey, block:FlxKey} = {
		attack: SPACE,
		block: LEFT
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.watch.addQuick('OP_TICK', OP_TICK);
		FlxG.watch.addQuick('OP_ATK_TICK', OP_ATK_TICK);
		FlxG.watch.addQuick('PLAYER_TICK', PLAYER_TICK);
		FlxG.watch.addQuick('PLAYER_CAN_DO_THINGS_TICK', PLAYER_CAN_DO_THINGS_TICK);

		PROGRESS_BAR_GROUP.updateHealthIndicators();
		PROGRESS_BAR_GROUP.OPPONENT_HEALTH_ICON.y -= 12;

		if (Global.keyJustReleased(ESCAPE))
		{
			togglePaused();
		}

		if (!paused)
		{
			OP_TICK++;
			PLAYER_TICK++;

			if (FlxG.random.bool(OP_ATK_CHANCE) && OPPONENT.animation.name == 'idle' && OP_TICK > OP_ATK_TICK)
			{
				OP_TICK = 0;
				OP_ATK_TICK = FlxG.random.int(OP_ATK_TICK_RAND_MIN, OP_ATK_TICK_RAND_MAX);
				Global.playSoundEffect('gameplay/attack-charge');
				OPPONENT.playAnimation('wind-up');
				opponentAnimationPosition();
				OP_DEF_CHANCE = FlxG.random.float(OP_DEF_CHANCE_DID_HIT, OP_DEF_CHANCE_DIDNT_HIT);
			}

			if (Global.anyKeysPressed([keys.attack, keys.block]) || Global.anyKeysJustReleased([keys.attack, keys.block]))
			{
				if (PLAYER.animation.name != 'idle')
					return;

				if (Global.keyJustReleased(keys.attack))
				{
					if (OPPONENT.animation.name != 'idle' || PLAYER_TICK < PLAYER_CAN_DO_THINGS_TICK)
						return;

					PLAYER_TICK = 0;

					if (FlxG.random.bool(OP_DEF_CHANCE))
					{
						OPPONENT.playAnimation('block');
						OP_TICK = FlxG.random.int(0, Std.int(OP_ATK_CHANCE / 1.5));
					}
					else
					{
						Global.playSoundEffect('gameplay/attack-failed');
						OPPONENT.playAnimation('hit');
						PROGRESS_BAR_GROUP.OPPONENT_HEALTH -= 1;
						OP_DEF_CHANCE = FlxG.random.float(OP_DEF_CHANCE_DIDNT_HIT / 2, OP_DEF_CHANCE_DIDNT_HIT);
						OP_ATK_TICK = FlxG.random.int(0, Std.int(OP_ATK_CHANCE / 1.1));
						PLAYER_TICK = FlxG.random.int(0, PLAYER_CAN_DO_THINGS_TICK);
					}

					PLAYER.playAnimation('punch');
				}

				if (Global.keyPressed(keys.block))
				{
					PLAYER.playAnimation('block');
				}
			}

			if (PLAYER.animation.name == 'block' && !Global.keyPressed(keys.block))
				PLAYER.playAnimation('idle');

			playerAnimationPosition();
		}

		if (PROGRESS_BAR_GROUP.OPPONENT_HEALTH < 1)
		{
			Global.switchState(new ResultsMenu(Std.int(PROGRESS_BAR_GROUP.PLAYER_HEALTH), Std.int(PROGRESS_BAR_GROUP.PLAYER_MAX_HEALTH),
				new Sidebit2EndCutscene(), 'port'));
		}
		else if (PROGRESS_BAR_GROUP.PLAYER_HEALTH < 1)
		{
			Global.switchState(new ResultsMenu(Std.int(PROGRESS_BAR_GROUP.OPPONENT_MAX_HEALTH - PROGRESS_BAR_GROUP.OPPONENT_HEALTH),
				Std.int(PROGRESS_BAR_GROUP.OPPONENT_MAX_HEALTH), new Worldmap('portilizen'), 'port'));
		}

		opponentAnimationPosition();
		playerAnimationPosition();

		PLAYER.animation.paused = paused;
		OPPONENT.animation.paused = paused;
	}

	public function playerAnimationPosition()
	{
		switch (PLAYER.animation.name)
		{
			case 'punch':
				PLAYER.x = PLAYER_POINT.x + 150;
				PLAYER.y = PLAYER_POINT.y;

			default:
				PLAYER.x = PLAYER_POINT.x;
				PLAYER.y = PLAYER_POINT.y;
		}
	}

	public function opponentAnimationPosition()
	{
		switch (OPPONENT.animation.name)
		{
			case 'wind-up':
				OPPONENT.x = OPPONENT_POINT.x - 150;
				OPPONENT.y = OPPONENT_POINT.y;

			case 'punch':
				OPPONENT.x = OPPONENT_POINT.x - (150 * 2);
				OPPONENT.y = OPPONENT_POINT.y;

			default:
				OPPONENT.x = OPPONENT_POINT.x;
				OPPONENT.y = OPPONENT_POINT.y;
		}
	}

	override function togglePaused()
	{
		super.togglePaused();

		sparrowBG.animation.paused = paused;
	}
}
