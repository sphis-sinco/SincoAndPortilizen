package sap.worldmap;

typedef PlayableCharacter =
{
	var character_display_name:String;
        var unlocked_when_loaded:Bool;
        
	var levels:Int;
        var level_number_offset:Int;

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

package sap.worldmap;

typedef PlayableCharacter =
{
	var character_display_name:String;
	var levels:Int;
        var level_number_offset:Int;

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
