package sap.worldmap;

class CharacterSelect extends State
{
	public static var CHARACTER_LIST:Array<String> = [];

	public static var CURRENT_SELECTION:Int = 0;

	public static var CHARACTER_BOX:CharSelector;
	public static var CHARACTER_SELECTION_BOX:CharSelector;

	public static var CHARACTER_ICON:CharIcon;

	override public function new()
	{
		super();

		CHARACTER_LIST = [];
		for (file in FileManager.readDirectory('assets/data/playable_characters'))
		{
			CHARACTER_LIST.push(file.split('.')[0]);
		}
		trace(CHARACTER_LIST);
	}

	override function create()
	{
		super.create();

		var backdrop:FlxSprite = new FlxSprite();
		backdrop.loadGraphic(FileManager.getImageFile('worldmap/character_select/back'), true, 160, 152);
		backdrop.animation.add('idle', [0, 1], 2);
		backdrop.animation.play('idle');
		add(backdrop);
		Global.scaleSprite(backdrop);
		backdrop.screenCenter();

		CHARACTER_BOX = new CharSelector();
		add(CHARACTER_BOX);
		CHARACTER_BOX.playAnimation('blank');
		CHARACTER_BOX.screenCenter();

                CHARACTER_ICON = new CharIcon(CHARACTER_LIST[CURRENT_SELECTION]);
		add(CHARACTER_ICON);
		CHARACTER_ICON.screenCenter();
		CHARACTER_ICON.x -= 32;

		CHARACTER_SELECTION_BOX = new CharSelector();
		add(CHARACTER_SELECTION_BOX);
		CHARACTER_SELECTION_BOX.screenCenter();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Worldmap.CURRENT_PLAYER_CHARACTER == CHARACTER_ICON.character)
		{
			if (CHARACTER_ICON.animation.name != 'confirm')
				CHARACTER_ICON.animation.play('confirm');
		}
		else
		{
			if (CHARACTER_ICON.animation.name != 'idle')
				CHARACTER_ICON.animation.play('idle', false, true);
		}

		if (Global.anyKeysJustReleased([LEFT, RIGHT]))
		{
			final left:Bool = Global.keyJustReleased(LEFT);

			CURRENT_SELECTION += (left) ? -1 : 1;

			if (CURRENT_SELECTION < 0)
			{
				CURRENT_SELECTION = 0;
			}
			else if (CURRENT_SELECTION > CHARACTER_LIST.length - 1)
			{
				CURRENT_SELECTION = CHARACTER_LIST.length - 1;
			}

                        CHARACTER_ICON.character = CHARACTER_LIST[CURRENT_SELECTION];
                        CHARACTER_ICON.refresh();
		}
	}
}

class CharSelector extends SparrowSprite
{
	override public function new()
	{
		super('worldmap/character_select/CharSelector');

		addAnimationByPrefix('idle', 'idle', 24, false);
		addAnimationByPrefix('blank', 'character-box', 24, false);
		addAnimationByPrefix('select', 'select', 24, false);
		addAnimationByPrefix('cant-select', 'cant-select', 24, false);

		playAnimation('idle');

		Global.scaleSprite(this, -2);
	}
}
