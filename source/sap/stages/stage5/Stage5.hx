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
	 * The opponent sprite
	 */
	public static var OBJ_OPPONENT:FlxSprite;

	/**
	 * The difficulty string
	 */
	public static var DIFFICULTY:String = 'normal';

	override public function new(difficulty:String)
	{
		super();

		DIFFICULTY = difficulty;
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

		add(OBJ_PLAYER);
		add(OBJ_OPPONENT);

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
	}

	override function postCreate()
	{
		super.postCreate();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.watch.addQuick('Player position', OBJ_PLAYER.getPosition());
		FlxG.watch.addQuick('Opponent position', OBJ_OPPONENT.getPosition());

		if (EDITOR_MODE)
		{
			editorModeTick();
		}
		else
		{
			gameplayTick();
		}
	}

	/**
	 * This controls everything related to the gameplay loop
	 */
	public static function gameplayTick():Void {}

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
		OBJ_PLAYER.makeGraphic(32, 64, FlxColor.PURPLE);
		OBJ_PLAYER.setPosition(480, 400);

		OBJ_OPPONENT = new FlxSprite();
		OBJ_OPPONENT.makeGraphic(32, 64, FlxColor.GREEN);
		OBJ_OPPONENT.setPosition(120, 400);
	}
}
