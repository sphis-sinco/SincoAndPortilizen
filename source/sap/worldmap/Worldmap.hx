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
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
