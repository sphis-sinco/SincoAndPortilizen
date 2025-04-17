package sap.worldmap;

typedef PlayableCharacter =
{
	var character_display_name:String;
	var levels:Int;

	var ?results_asset_prefix:String;
}

class PlayableCharacterManager
{
	public static function readPlayableCharacterJSON(character:String):PlayableCharacter
	{
		var json:PlayableCharacter = null;

		json = FileManager.getJSON(FileManager.getDataFile('playable_characters/${character}.json'));

		return json;
	}
}
