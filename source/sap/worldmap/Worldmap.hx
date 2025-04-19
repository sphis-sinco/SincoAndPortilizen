package sap.worldmap;

import sap.mainmenu.PlayMenu;

class Worldmap extends State
{
	public static var CURRENT_PLAYER_CHARACTER:String = 'sinco';
	public static var CURRENT_PLAYER_CHARACTER_JSON:PlayableCharacter = null;
	public static var CURRENT_PLAYER_LEVELS:Int = 0;
	public static var CURRENT_PLAYER_SELECTION_OFFSET:Int = 0;

	public static var CURRENT_SELECTION:Int = 0;
	public static var CURRENT_DIFFICULTY:String = 'normal';

	public static var LEVEL_TEXT:FlxText;
	public static var DIFFICULTY_TEXT:FlxText;

	public static var CHARACTER_SELECT_BUTTON:FlxSprite;

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
		LEVEL_TEXT.y -= LEVEL_TEXT.height / 2;

		DIFFICULTY_TEXT = new FlxText(0, 0, 0, 'Bye', 32);
		add(DIFFICULTY_TEXT);
		DIFFICULTY_TEXT.screenCenter();
		DIFFICULTY_TEXT.y += DIFFICULTY_TEXT.height / 2;

		CHARACTER_SELECT_BUTTON = new FlxSprite();
		CHARACTER_SELECT_BUTTON.loadGraphic(FileManager.getImageFile('worldmap/charSelButton'));
		add(CHARACTER_SELECT_BUTTON);
		Global.scaleSprite(CHARACTER_SELECT_BUTTON, -2);
		CHARACTER_SELECT_BUTTON.setPosition(8 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER, 8 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		LEVEL_TEXT.text = '${CURRENT_PLAYER_CHARACTER_JSON.character_display_name}: level ${CURRENT_SELECTION + 1 + CURRENT_PLAYER_SELECTION_OFFSET}';
		LEVEL_TEXT.screenCenter(X);

		DIFFICULTY_TEXT.text = '${Global.keyPressed(LEFT) ? '-' : '<'} ${CURRENT_DIFFICULTY} ${Global.keyPressed(RIGHT) ? '-' : '>'}';
		DIFFICULTY_TEXT.screenCenter(X);

		switch (CURRENT_DIFFICULTY.toLowerCase())
		{
			case 'easy':
				DIFFICULTY_TEXT.color = FlxColor.LIME;
			case 'normal':
				DIFFICULTY_TEXT.color = FlxColor.YELLOW;
			case 'hard':
				DIFFICULTY_TEXT.color = FlxColor.RED;
			case 'extreme':
				DIFFICULTY_TEXT.color = FlxColor.PINK;
		}

		controlManagement();

		if (FlxG.mouse.overlaps(CHARACTER_SELECT_BUTTON) && FlxG.mouse.justReleased)
		{
			Global.switchState(new CharacterSelect());
		}
	}

	public static function controlManagement():Void
	{
		if (Global.anyKeysJustReleased([LEFT, RIGHT]))
		{
			CURRENT_DIFFICULTY = StageGlobals.cycleDifficulty(CURRENT_DIFFICULTY, Global.keyJustReleased(LEFT));
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
		else if (Global.keyJustReleased(ESCAPE))
		{
			Global.switchState(new PlayMenu());
		}
	}
}
