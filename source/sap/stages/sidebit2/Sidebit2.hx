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

		DIFFICULTY = difficulty;
		DIFFICULTY_JSON = FileManager.getJSON(FileManager.getDataFile('stages/sidebit2/${difficulty}.json'));

		OP_ATK_CHANCE = DIFFICULTY_JSON.op_attack_chance;
	}

	public static var PLAYER:Sidebit2Character;
	public static var OPPONENT:Sidebit2Character;

	public static var PLAYER_POINT:FlxPoint;
	public static var OPPONENT_POINT:FlxPoint;

	public static var TUTORIAL_SHADER:AdjustColorShader;

	override function create()
	{
		super.create();

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
						PLAYER.playAnimation('hit');
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

	override function postCreate()
	{
		super.postCreate();
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
						OP_TICK = FlxG.random.int(0, Std.int(OP_ATK_CHANCE / 1.1));
					}
					else
					{
						OPPONENT.playAnimation('hit');
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
}
