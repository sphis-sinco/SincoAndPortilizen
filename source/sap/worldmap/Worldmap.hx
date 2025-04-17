package sap.worldmap;

class Worldmap extends State
{
	public static var CURRENT_PLAYER_CHARACTER:String = 'sinco';
	public static var CURRENT_PLAYER_CHARACTER_JSON:PlayableCharacter = null;
	public static var CURRENT_PLAYER_LEVELS:Int = 0;
	public static var CURRENT_PLAYER_SELECTION_OFFSET:Int = 0;

	public static var CURRENT_SELECTION:Int = 0;

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
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		LEVEL_TEXT.text = 'Level ${CURRENT_SELECTION + 1 + CURRENT_PLAYER_SELECTION_OFFSET}';

		controlManagement();
	}

	public static function controlManagement():Void
	{
		if (Global.anyKeysJustReleased([UP, DOWN]))
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
	}
}
