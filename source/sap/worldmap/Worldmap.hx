package sap.worldmap;

import sap.mainmenu.PlayMenu;

class Worldmap extends State
{
	public static var SIDEBIT_MODE:Bool = false;
	public static var SIDEBITS:Array<String> = [];
        public static var SIDEBIT_JSONS:Array<Dynamic> = [];

	public static var CURRENT_PLAYER_CHARACTER:String = 'sinco';
	public static var CURRENT_PLAYER_CHARACTER_JSON:PlayableCharacter = null;
	public static var CURRENT_PLAYER_LEVELS:Int = 0;
	public static var CURRENT_PLAYER_SELECTION_OFFSET:Int = 0;

	public static var CURRENT_SELECTION:Int = 0;
	public static var CURRENT_DIFFICULTY:String = 'normal';

	public static var LEVEL_TEXT:FlxText;
	public static var DIFFICULTY_TEXT:FlxText;

	public static var CHARACTER_SELECT_BUTTON:FlxSprite;

	override public function new(character:String = null)
	{
		super();

		// In theory this should just make it use it's own variable?
		if (character != null)
		{
			CURRENT_PLAYER_CHARACTER = character;
		}

		init();
		initSidebits();
	}

	public static function init():Void
	{
		CURRENT_PLAYER_CHARACTER_JSON = PlayableCharacterManager.readPlayableCharacterJSON(CURRENT_PLAYER_CHARACTER);
		CURRENT_PLAYER_LEVELS = CURRENT_PLAYER_CHARACTER_JSON.levels;
		CURRENT_PLAYER_SELECTION_OFFSET = CURRENT_PLAYER_CHARACTER_JSON.level_number_offset;
	}

	public static function initSidebits():Void
	{
		SIDEBITS = [];

		var denied:Int = 0;

		for (sidebit in FileManager.readDirectory('assets/data/sidebits'))
		{
			final sidebitName:String = sidebit.split('.')[0];
			final sidebitJson = FileManager.getJSON(FileManager.getDataFile('sidebits/$sidebit'));
                        SIDEBIT_JSONS.push(sidebitJson);

			if (SIDEBIT_MODE
				&& (!sidebitJson.sidebit_ids.contains(CURRENT_PLAYER_CHARACTER_JSON.sidebit_id)
					|| !CURRENT_PLAYER_CHARACTER_JSON.has_sidebits))
				denied++;
			else
				SIDEBITS.push(sidebitName);

                        if (denied == SIDEBIT_JSONS.length && SIDEBIT_MODE)
                                switchModes();
		}
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

		if (!SIDEBIT_MODE)
			LEVEL_TEXT.text = 'Level ${CURRENT_SELECTION + 1 + CURRENT_PLAYER_SELECTION_OFFSET} (${CURRENT_PLAYER_CHARACTER_JSON.character_display_name})';
		else
			LEVEL_TEXT.text = 'Sidebit ${CURRENT_SELECTION + 1} (${SIDEBIT_JSONS[CURRENT_SELECTION].player})';
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

			final max:Int = (SIDEBIT_MODE) ? SIDEBITS.length - 1 : CURRENT_PLAYER_LEVELS - 1;
			if (CURRENT_SELECTION > max)
				CURRENT_SELECTION = max;
		}
		else if (Global.keyJustReleased(ENTER))
		{
			Global.callScriptFunction('worldmapSelection', [
				CURRENT_PLAYER_CHARACTER,
				CURRENT_SELECTION + 1 + ((SIDEBIT_MODE) ? 0 : CURRENT_PLAYER_SELECTION_OFFSET),
				SIDEBIT_MODE
			]);
		}
		else if (Global.keyJustReleased(ESCAPE))
		{
			Global.switchState(new PlayMenu());
		}
		else if (Global.keyJustReleased(TAB))
		{
			switchModes();
		}
	}

	public static function switchModes():Void
	{
		SIDEBIT_MODE = !SIDEBIT_MODE;
		CURRENT_SELECTION = 0;
		initSidebits();
	}
}
