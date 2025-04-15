package sap.worldmap;

class MapCharacter extends FlxSprite
{
	// This is so I don't have to do this:
	// char = (char == "sinco") ? "port" : "sinco"
	public var characterList:Map<String, String> = ["sinco" => "port", "port" => "sinco"];

	override public function new(curchar:String = 'sinco'):Void
	{
		super();

		char = characterList.get(curchar.toLowerCase());
		swapCharacter();
		animation.play('idle');
	}

	public var char:String = 'sinco';

	public function swapCharacter():Void
	{
		char = characterList.get(char);

		loadGraphic(FileManager.getImageFile('worldmap/${char}WorldMap'), true, 16, 16);
		animation.add('idle', [0]);
		animation.add('jump', [1]);
		animation.add('wait', [2]);
		animation.add('run', [3, 4], 12);
		Global.scaleSprite(this);
	}

	public function animationname():String
	{
		return animation.name;
	}

	public function swappedchar():String
	{
		return characterList.get(char);
	}
}
