package sap.stages.stage5;

class Stage5 extends State
{
	/**
	 *  This allows for offset editing when needed
	 */
	private static var EDITOR_MODE:Bool = false;

	/**
	 * The speed in which you can move around editable objects in EDITOR_MODE without the SHIFT key pressed
	 */
	private static var EDITABLE_OBJ_MOVEMENT_SPEED:Int = 10;

	/**
	 * The speed in which you can move around editable objects in EDITOR_MODE with the SHIFT key pressed
	 */
	private static var EDITABLE_OBJ_SHIFT_MOVEMENT_SPEED:Int = 1;

	/**
	 * The player sprite
	 */
	public static var OBJ_PLAYER:FlxSprite;

	/**
	 * The player attack sprite
	 */
	public static var OBJ_PLAYER_ATTACK:FlxSprite;

	/**
	 * The current charge the player has
	 */
	public static var PLAYER_CHARGE:Int = 0;

	/**
	 * The opponent sprite
	 */
	public static var OBJ_OPPONENT:FlxSprite;

	/**
	 * The opponent attack sprite
	 */
	public static var OBJ_OPPONENT_ATTACK:FlxSprite;

	/**
	 * The current charge the opponent has
	 */
	public static var OPPONENT_CHARGE:Int = 0;

	/**
	 * The current tick of the opponent's charge: when it is a certain random value the opponent will stop charging
	 */
	public static var OPPONENT_CHARGE_TICK:Int = 0;

	/**
	 * The tick goal until `OPPONENT_CHARGE` is incremented
	 */
	public static var OPPONENT_CHARGE_TICK_GOAL:Int = 10;

	/**
	 * The certain random value minimum where the opponent pauses charging
	 */
	public static var OPPONENT_CHARGE_RANDOM_TICK_PAUSE_MIN:Int = 2;

	/**
	 * The certain random value maximum where the opponent pauses charging
	 */
	public static var OPPONENT_CHARGE_RANDOM_TICK_PAUSE_MAX:Int = 8;

	/**
	 * The recharge ticks starting value
	 */
	public static var OPPONENT_PAUSE_TICK_START_VALUE:Int = 5;

	/**
	 * The chance of the opponent pausing when the conditions are right
	 */
	public static var OPPONENT_PAUSE_CHANGE:Float = 45;

	/**
	 * This is how much `OPPONENT_PAUSE_CHANGE` changes when the player's charge is ahead of the opponents
	 */
	public static var OPPONENT_LOCKIN_OFFSET:Float = 0.1;

	/**
	 * The recharge ticks: counts down
	 */
	public static var OPPONENT_PAUSE_TICK:Int = 0;

	/**
	 * The tick goal until `OPPONENT_PAUSE_TICK` is decreased
	 */
	public static var OPPONENT_PAUSE_TICK_GOAL:Int = 2;

	/**
	 * How long you are in the level for
	 */
	public static var TIMER_SECONDS:Int = 60;

	/**
	 * Time elapsed in the level
	 */
	public static var TIME_SECONDS:Int = 0;

	/**
	 * The text displaying the time left in the level
	 */
	public static var TIMER_TEXT:FlxText;

	/**
	 * This controls if gameplay is being executed or not
	 */
	public static var IN_CUTSCENE:Bool = false;

	/**
	 * The difficulty string
	 */
	public static var DIFFICULTY:String = 'normal';

	/**
	 * The difficulty JSON
	 */
	public static var DIFFICULTY_JSON:Stage5DifficultyJson;

	/**
	 * This helps the results menu when it comes to medals
	 */
	public static var RUNNING:Bool = false;

	override public function new(difficulty:String)
	{
		super();

		DIFFICULTY = difficulty;
		DIFFICULTY_JSON = FileManager.getJSON(FileManager.getDataFile('stages/stage5/${DIFFICULTY}.json'));

		OPPONENT_CHARGE_TICK_GOAL = DIFFICULTY_JSON.opponent_charge_tick_goal;
		OPPONENT_CHARGE_RANDOM_TICK_PAUSE_MIN = DIFFICULTY_JSON.opponent_charge_random_tick_pause_max;
		OPPONENT_CHARGE_RANDOM_TICK_PAUSE_MAX = DIFFICULTY_JSON.opponent_charge_random_tick_pause_min;
		OPPONENT_PAUSE_TICK_START_VALUE = DIFFICULTY_JSON.opponent_pause_tick_start_value;
		OPPONENT_PAUSE_CHANGE = DIFFICULTY_JSON.opponent_pause_change;
		OPPONENT_LOCKIN_OFFSET = DIFFICULTY_JSON.opponent_lockin_offset;
		OPPONENT_PAUSE_TICK_GOAL = DIFFICULTY_JSON.opponent_pause_tick_goal;

		TIMER_SECONDS = DIFFICULTY_JSON.timer;

		IN_CUTSCENE = false;

		RUNNING = true;
	}

	override function create()
	{
		super.create();

		Global.changeDiscordRPCPresence('Stage 5 (${DIFFICULTY.toUpperCase()}): Rival Clash', null);

		var bg:FlxSprite = new FlxSprite().loadGraphic(FileManager.getImageFile('gameplay/timeVoid-stage5'));
		add(bg);
		bg.screenCenter();
		Global.scaleSprite(bg);

		initializeCharacters();
		initializeAttacks();

		add(OBJ_PLAYER);
		add(OBJ_OPPONENT);

		add(OBJ_PLAYER_ATTACK);
		add(OBJ_OPPONENT_ATTACK);

		// PRESS [SPACE] TO CHARGE \\
		var tutorial1:FlxSprite = new FlxSprite();
		tutorial1.loadGraphic(FileManager.getImageFile('gameplay/tutorials/pixel/Space-Charge'));
		add(tutorial1);
		Global.scaleSprite(tutorial1, -2);
		tutorial1.screenCenter();
		tutorial1.y -= tutorial1.height;

		// THE MOST POWERFUL ATTACK WINS \\
		var tutorial2:FlxSprite = new FlxSprite();
		tutorial2.loadGraphic(FileManager.getImageFile('gameplay/tutorials/pixel/Strongest-wins'));
		add(tutorial2);
		Global.scaleSprite(tutorial2, -2);
		tutorial2.screenCenter();
		tutorial2.y += tutorial2.height;

		FlxTimer.wait(3, () ->
		{
			FlxTween.tween(tutorial1, {alpha: 0}, 1);
			FlxTween.tween(tutorial2, {alpha: 0}, 1);
		});

		if (!EDITOR_MODE)
			FlxTimer.wait(TIMER_SECONDS, function()
			{
				levelEndSequence();
			});

		PLAYER_CHARGE = OPPONENT_CHARGE = 0;
		OPPONENT_CHARGE_TICK = OPPONENT_PAUSE_TICK = 0;

                TIME_SECONDS = 0;

                TIMER_TEXT = new FlxText(10, 64, 0, "60", 64);
		TIMER_TEXT.screenCenter(X);
		add(TIMER_TEXT);
		StageGlobals.waitSec(TIMER_SECONDS, TIME_SECONDS, TIMER_TEXT);
	}

	/**
	 * This is the ending sequence, when the attacks fly at their targets
	 */
	public static function levelEndSequence():Void
	{
		IN_CUTSCENE = true;

		final speed:Int = 2;
		final won:Bool = PLAYER_CHARGE > OPPONENT_CHARGE;

		Global.playSoundEffect('gameplay/attack');

		FlxTween.tween(OBJ_PLAYER_ATTACK, {x: OBJ_OPPONENT.x, y: OBJ_OPPONENT.y}, speed, {
			ease: FlxEase.sineInOut,
			onStart: function(tween)
			{
				OBJ_PLAYER.animation.play('attack');
			}
		});
		FlxTween.tween(OBJ_OPPONENT_ATTACK, {x: OBJ_PLAYER.x, y: OBJ_PLAYER.y}, speed, {
			ease: FlxEase.sineInOut,
			onStart: function(tween)
			{
				OBJ_OPPONENT.animation.play('attack');
			},
			onUpdate: function(tween)
			{
				if (OBJ_OPPONENT_ATTACK.overlaps(OBJ_PLAYER_ATTACK))
				{
					Global.playSoundEffect('gameplay/attack-failed');
					if (won)
						OBJ_OPPONENT_ATTACK.destroy();
					else
						OBJ_PLAYER_ATTACK.destroy();
				}
			}
		});

		FlxTimer.wait(speed, function()
		{
			Global.playSoundEffect('gameplay/attack-failed');
			Global.switchState(new ResultsMenu((won) ? PLAYER_CHARGE : OPPONENT_CHARGE - PLAYER_CHARGE, (won) ? PLAYER_CHARGE : OPPONENT_CHARGE,
				(won) ? new PostStage5Cutscene() : new Worldmap(), 'port'));
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.watch.addQuick('Player position', OBJ_PLAYER.getPosition());
		FlxG.watch.addQuick('Opponent position', OBJ_OPPONENT.getPosition());

		FlxG.watch.addQuick('Player charge', PLAYER_CHARGE);
		FlxG.watch.addQuick('Opponent charge', OPPONENT_CHARGE);
		FlxG.watch.addQuick('Opponent pause chance', OPPONENT_PAUSE_CHANGE);

		FlxG.watch.addQuick('Opponent charge tick', OPPONENT_CHARGE_TICK);
		FlxG.watch.addQuick('Opponent pause tick', OPPONENT_PAUSE_TICK);

                if (Std.parseInt(TIMER_TEXT.text) < 0)
                {
                        TIMER_TEXT.text = '0';
                }

		if (EDITOR_MODE)
			editorModeTick();
		else if (!IN_CUTSCENE)
		{
			OBJ_PLAYER_ATTACK.setPosition(OBJ_PLAYER.x + ((OBJ_PLAYER.animation.name == 'intro') ? 32 : 0),
				OBJ_PLAYER.y - (OBJ_PLAYER_ATTACK.height * ((OBJ_PLAYER_ATTACK.scale.y / 4) + 1)) * 2);
			OBJ_OPPONENT_ATTACK.setPosition(OBJ_OPPONENT.x + 20, OBJ_OPPONENT.y - (OBJ_OPPONENT_ATTACK.height * ((OBJ_OPPONENT_ATTACK.scale.y / 4) + 1)) * 2);

			OBJ_PLAYER_ATTACK.scale.y = OBJ_PLAYER_ATTACK.scale.x = 1 + (PLAYER_CHARGE / 100);
			OBJ_OPPONENT_ATTACK.scale.y = OBJ_OPPONENT_ATTACK.scale.x = 1 + (OPPONENT_CHARGE / 100);

			gameplayTick();
		}
	}

	/**
	 * This controls everything related to the gameplay loop
	 */
	public static function gameplayTick():Void
	{
		if (OPPONENT_PAUSE_TICK == 0)
		{
			opponentChargeTick();
		}
		else
		{
			OPPONENT_PAUSE_TICK--;
		}

		if (Global.keyJustReleased(SPACE))
		{
			if (OBJ_PLAYER.animation.name != 'charge')
				OBJ_PLAYER.animation.play('charge');

			PLAYER_CHARGE++;

			if (PLAYER_CHARGE > OPPONENT_CHARGE)
			{
				OPPONENT_PAUSE_CHANGE -= OPPONENT_LOCKIN_OFFSET;
			}
		}

		if (Global.keyJustReleased(R))
		{
			Global.switchState(new Stage5(DIFFICULTY));
			FlxG.camera.flash(FlxColor.WHITE, .25, null, true);
		}
	}

	/**
	 * Controls opponent charge ticks
	 */
	public static function opponentChargeTick():Void
	{
		OPPONENT_CHARGE_TICK++;
		OBJ_OPPONENT.animation.play('charge');

		if (OPPONENT_CHARGE_TICK == FlxG.random.int(OPPONENT_CHARGE_RANDOM_TICK_PAUSE_MIN, OPPONENT_CHARGE_RANDOM_TICK_PAUSE_MAX)
			&& FlxG.random.bool(OPPONENT_PAUSE_CHANGE))
		{
			OPPONENT_PAUSE_TICK = OPPONENT_PAUSE_TICK_START_VALUE;
		}
		else
		{
			opponentTickGoalCheck();
		}
	}

	/**
	 * Checks if `OPPONENT_CHARGE_TICK` is `OPPONENT_CHARGE_TICK_GOAL` and if so it increments `OPPONENT_CHARGE`
	 */
	public static function opponentTickGoalCheck():Void
	{
		if (OPPONENT_CHARGE_TICK == OPPONENT_CHARGE_TICK_GOAL)
		{
			OPPONENT_CHARGE++;
			OPPONENT_CHARGE_TICK = 0;
		}
	}

	/**
	 *  This controls everything related to EDITOR_MODE
	 */
	private static function editorModeTick():Void
	{
		final speed:Int = (Global.keyPressed(SHIFT)) ? EDITABLE_OBJ_SHIFT_MOVEMENT_SPEED : EDITABLE_OBJ_MOVEMENT_SPEED;

		if (Global.anyKeysPressed([UP, LEFT, DOWN, RIGHT]))
		{
			if (Global.anyKeysPressed([LEFT, RIGHT]))
				OBJ_PLAYER.x += (Global.keyPressed(LEFT)) ? -speed : speed;
			if (Global.anyKeysPressed([UP, DOWN]))
				OBJ_PLAYER.y += (Global.keyPressed(UP)) ? -speed : speed;
		}
		else if (Global.anyKeysPressed([W, A, S, D]))
		{
			if (Global.anyKeysPressed([A, D]))
				OBJ_OPPONENT.x += (Global.keyPressed(A)) ? -speed : speed;
			if (Global.anyKeysPressed([W, S]))
				OBJ_OPPONENT.y += (Global.keyPressed(W)) ? -speed : speed;
		}
	}

	/**
	 * This initalizes the player and opponent sprites, positioning them, loading their assets, etc
	 */
	public static function initializeCharacters():Void
	{
		OBJ_PLAYER = new FlxSprite();
		OBJ_PLAYER.loadGraphic(FileManager.getImageFile('gameplay/port stages/Stage5Portilizen'), true, 64, 64);
		OBJ_PLAYER.animation.add('intro', [0], 1, false);
		OBJ_PLAYER.animation.add('charge', [1], 1, false);
		OBJ_PLAYER.animation.add('attack', [2], 1, false);
		OBJ_PLAYER.animation.play('intro');
		OBJ_PLAYER.setPosition(480, 400);
		// OBJ_PLAYER.shader = getRimLighting('Portilizen');
		Global.scaleSprite(OBJ_PLAYER, -2);

		OBJ_OPPONENT = new FlxSprite();
		OBJ_OPPONENT.loadGraphic(FileManager.getImageFile('gameplay/port stages/Stage5STCS'), true, 64, 64);
		OBJ_OPPONENT.animation.add('intro', [0], 1, false);
		OBJ_OPPONENT.animation.add('charge', [1], 1, false);
		OBJ_OPPONENT.animation.add('attack', [2], 1, false);
		OBJ_OPPONENT.animation.play('intro');
		OBJ_OPPONENT.setPosition(100, 400);
		// OBJ_OPPONENT.shader = getRimLighting(null); // 'STCS');
		Global.scaleSprite(OBJ_OPPONENT, -2);
	}

	/**
	 * Returns a rim lighting shader with an altMask according to the character you want
	 * @param char The character shadermask you would like
	 * @return DropShadowShader
	 */
	public static function getRimLighting(char:String = null):DropShadowShader
	{
		var rim:DropShadowShader = new DropShadowShader();
		rim.setAdjustColor(-25, -5, 0, 0);
		rim.color = 0xFF445664;
		rim.antialiasAmt = 0;
		rim.distance = 10;

		rim.angle = 90;
		rim.maskThreshold = 1;
		if (char != null)
		{
			rim.useAltMask = true;
			rim.loadAltMask(FileManager.getImageFile('gameplay/port stages/Stage5${char}-ShaderMask'));
		}
		return rim;
	}

	/**
	 * This initalizes the attack sprites
	 */
	function initializeAttacks()
	{
		OBJ_PLAYER_ATTACK = new FlxSprite();
		OBJ_PLAYER_ATTACK.loadGraphic(FileManager.getImageFile('gameplay/port stages/Stage5PortilizenAttack'));
		// OBJ_PLAYER_ATTACK.shader = getRimLighting('Attack');

		OBJ_OPPONENT_ATTACK = new FlxSprite();
		OBJ_OPPONENT_ATTACK.loadGraphic(FileManager.getImageFile('gameplay/port stages/Stage5STCSAttack'));
		// OBJ_OPPONENT_ATTACK.shader = getRimLighting('Attack');
	}
}
