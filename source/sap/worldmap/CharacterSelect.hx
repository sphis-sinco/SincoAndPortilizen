package sap.worldmap;

class CharacterSelect extends State
{
	public static var CHARACTER_LIST:Array<String> = [];

	public static var CHARACTER_BOX:CharSelector;
	public static var CHARACTER_SELECTION_BOX:CharSelector;

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

                CHARACTER_SELECTION_BOX = new CharSelector();
                add(CHARACTER_SELECTION_BOX);
                Global.scaleSprite(CHARACTER_SELECTION_BOX, -1);
                CHARACTER_SELECTION_BOX.screenCenter();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
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
