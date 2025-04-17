package sap.worldmap;

class Worldmap extends State
{
	public static var CURRENT_PLAYER_CHARACTER:String = 'sinco';
	public static var CURRENT_PLAYER_CHARACTER_JSON:PlayableCharacter = null;
	public static var CURRENT_PLAYER_LEVELS:Int = 0;
	public static var CURRENT_PLAYER_SELECTION_OFFSET:Int = 0;

	public static var CURRENT_SELECTION:Int = 0;
	public static var CURRENT_DIFFICULTY:String = 'normal';

	public static var LEVEL_TEXT:FlxText;

	override public function new(character:String = 'sinco')
	{
		super();

		CURRENT_PLAYER_CHARACTER = character;
		CURRENT_PLAYER_CHARACTER_JSON = PlayableCharacterManager.readPlayableCharacterJSON(CURRENT_PLAYER_CHARACTER);
		CURRENT_PLAYER_LEVELS = CURRENT_PLAYER_CHARACTER_JSON.levels;
		CURRENT_PLAYER_SELECTION_OFFSET = CURRENT_PLAYER_CHARACTER_JSON.level_number_offset;
	}

	override function create()
	{
		super.create();

		CURRENT_SELECTION = 0;

		var background:FlxSprite = new FlxSprite();
		background.loadGraphic(FileManager.getImageFile('worldmap/worldmapBG'));
		add(background);
		Global.scaleSprite(background);
		background.screenCenter();

		var bar:FlxSprite = new FlxSprite();
		bar.makeGraphic(FlxG.width, 32 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER, FlxColor.BLACK);
		add(bar);
		bar.screenCenter();

		LEVEL_TEXT = new FlxText(0, 0, 0, 'Hi', 32);
		add(LEVEL_TEXT);
		LEVEL_TEXT.screenCenter();
		LEVEL_TEXT.y -= LEVEL_TEXT.height;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		LEVEL_TEXT.text = '${CURRENT_PLAYER_CHARACTER_JSON.character_display_name}: level ${CURRENT_SELECTION + 1 + CURRENT_PLAYER_SELECTION_OFFSET}';
		LEVEL_TEXT.screenCenter(X);

		controlManagement();
	}

	public static function controlManagement():Void
	{
		if (Global.anyKeysJustReleased([LEFT, RIGHT]))
		{
			var left:Bool = !Global.keyJustReleased(RIGHT);

			if (CURRENT_DIFFICULTY == StageGlobals.EASY_DIFF)
			{
				CURRENT_DIFFICULTY = (left) ? StageGlobals.EXTREME_DIFF : StageGlobals.NORMAL_DIFF;
			}
			else if (CURRENT_DIFFICULTY == StageGlobals.NORMAL_DIFF)
			{
				CURRENT_DIFFICULTY = (left) ? StageGlobals.EASY_DIFF : StageGlobals.HARD_DIFF;
			}
			else if (CURRENT_DIFFICULTY == StageGlobals.HARD_DIFF)
			{
				CURRENT_DIFFICULTY = (left) ? StageGlobals.NORMAL_DIFF : StageGlobals.EXTREME_DIFF;
			}
			else if (CURRENT_DIFFICULTY == StageGlobals.EXTREME_DIFF)
			{
				CURRENT_DIFFICULTY = (left) ? StageGlobals.HARD_DIFF : StageGlobals.EASY_DIFF;
			}
		}
		else if (Global.anyKeysJustReleased([UP, DOWN]))
		{
			if (Global.keyJustReleased(DOWN))
			{
				CURRENT_SELECTION--;
			}
			else
			{
				CURRENT_SELECTION++;
			}

			if (CURRENT_SELECTION < 0)
				CURRENT_SELECTION = 0;

			if (CURRENT_SELECTION > CURRENT_PLAYER_LEVELS - 1)
				CURRENT_SELECTION = CURRENT_PLAYER_LEVELS - 1;
		}
		else if (Global.keyJustReleased(ENTER))
		{
			Global.callScriptFunction('worldmapSelection', [
				CURRENT_PLAYER_CHARACTER,
				CURRENT_SELECTION + 1 + CURRENT_PLAYER_SELECTION_OFFSET
			]);
		}
	}
}
