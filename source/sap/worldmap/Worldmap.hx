package sap.worldmap;

class Worldmap extends State
{
        public static var CURRENT_PLAYER_CHARACTER:String = 'sinco';
        public static var CURRENT_PLAYER_CHARACTER_JSON:PlayableCharacter = null;

	override public function new(character:String = 'sinco')
	{
		super();
                
                CURRENT_PLAYER_CHARACTER = character;
                CURRENT_PLAYER_CHARACTER_JSON = PlayableCharacterManager.readPlayableCharacterJSON(CURRENT_PLAYER_CHARACTER);
	}

	override function create()
	{
		super.create();

                var background:FlxSprite = new FlxSprite();
                background.loadGraphic(FileManager.getImageFile('worldmap/worldmapBG'));
                add(background);
                Global.scaleSprite(background);
                background.screenCenter();

                var bar:FlxSprite = new FlxSprite();
                bar.makeGraphic(FlxG.width, 32 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER, FlxColor.BLACK);
                add(bar);
                bar.screenCenter();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
