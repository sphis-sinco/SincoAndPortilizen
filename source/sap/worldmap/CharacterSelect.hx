package sap.worldmap;

class CharacterSelect extends State
{
	public static var CHARACTER_LIST:Array<String> = [];

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
                backdrop.animation.add('idle', [0,1], 2);
                backdrop.animation.play('idle');
		add(backdrop);
		Global.scaleSprite(backdrop);
		backdrop.screenCenter();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
