package sap.stages.stage5;

class Stage5 extends State
{
	public static var OBJ_PLAYER:FlxSprite;
	public static var OBJ_OPPONENT:FlxSprite;

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

		initializeCharacters();

		add(OBJ_PLAYER);
	}

	override function postCreate()
	{
		super.postCreate();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public static function initializeCharacters():Void
	{
		OBJ_PLAYER = new FlxSprite();
		OBJ_PLAYER.makeGraphic(32, 64, FlxColor.PURPLE);

		OBJ_OPPONENT = new FlxSprite();
		OBJ_OPPONENT.makeGraphic(32, 64, FlxColor.GREEN);
	}
}
