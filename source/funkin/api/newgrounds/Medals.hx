package funkin.api.newgrounds;

#if FEATURE_NEWGROUNDS
import io.newgrounds.objects.Medal as MedalData;

class Medals
{
	public static var medalJSON:Array<MedalJSON> = [];

	public static function listMedalData():Map<Medal, MedalData>
	{
		var medalList = NewgroundsClient.instance.medals;

		if (medalList == null)
		{
			trace('[NEWGROUNDS] Not logged in, cannot fetch medal data!');
			return [];
		}
		else
		{
			// TODO: Why do I have to do this, @:nullSafety is fucked up
			var result:Map<Medal, MedalData> = [];

			for (medalId in medalList.keys())
			{
				var medalData = medalList.get(medalId);
				if (medalData == null)
					continue;

				// A little hacky, but it works.
				result.set(cast medalId, medalData);
			}

			return result;
		}
	}

	public static function award(medal:Medal):Void
	{
		if (NewgroundsClient.instance.isLoggedIn())
		{
			var medalList = NewgroundsClient.instance.medals;
			@:privateAccess
			if (medalList == null || medalList._map == null)
				return;

			var medalData:Null<MedalData> = medalList.get(medal.getId());
			@:privateAccess
			if (medalData == null || medalData._data == null)
			{
				trace('[NEWGROUNDS] Could not retrieve data for medal: ${medal}');
				return;
			}
			else if (!medalData.unlocked)
			{
				trace('[NEWGROUNDS] Awarding medal (${medal}).');
				medalData.sendUnlock();

				if ((medalJSON?.length ?? 0) == 0)
					loadMedalJSON();

				var localMedalData:Null<MedalJSON> = medalJSON.filter(function(jsonMedal)
				{
					#if FEATURE_NEWGROUNDS_TESTING_MEDALS
					return medal == Medal.DummyMedal;
					#else
					return medal == jsonMedal.id;
					#end
				})[0];
			}
			else
			{
				trace('[NEWGROUNDS] User already has medal (${medal}).');
			}
		}
		else
		{
			trace('[NEWGROUNDS] Attempted to award medal (${medal}), but not logged into Newgrounds.');
		}
	}

	public static function loadMedalJSON():Void
	{
		var jsonPath = FileManager.getJSON(FileManager.getJSON('ng-medals'));

		var jsonString = Assets.getText(jsonPath);

		var parser = new json2object.JsonParser<Array<MedalJSON>>();
		parser.ignoreUnknownVariables = false;
		trace('[NEWGROUNDS] Parsing local medal data...');
		parser.fromJson(jsonString, jsonPath);

		if (parser.errors.length > 0)
		{
			trace('[NEWGROUNDS] Failed to parse local medal data!');
			for (error in parser.errors)
				throw error;
			medalJSON = [];
		}
		else
		{
			medalJSON = parser.value;
		}
	}

	public static function awardLevel(id:String):Void
	{
		switch (id)
		{
			default:
				trace('[NEWGROUNDS] Level does not have a medal! (${id}).');
		}
	}
}
#end

/**
 * Represents NG Medal data in a JSON format.
 */
typedef MedalJSON =
{
	/**
	 * Medal ID to use for release builds
	 */
	var id:Int;
}

enum abstract Medal(Int) from Int to Int
{
	/**
	 * Represents an undefined or invalid medal.
	 */
	var Unknown = -1;

  // Dumbass
  var DummyMedal = 83846;

  // MENUS
  var Welcome = 83706;
  var HuhSomeoneCares = 83707;

  // STAGE 1
  var FakerClash = 83708;
  var TheOriginalStandsOntop = 83709;

  // STAGE 2
  var Protector = 83712;
  var TrueProtector = 83713;

  // STAGE 3

  // STAGE 4
  var DimensionsReached = 83710;

  // STAGE 5
  var TheOCOfHistory = 83846;
  var BrothersSplitAgain = 83846;

  // STAGE 6

  // SIDEBIT 1
  var TheConsistentless = 83846;
  var TheOCOfToday = 83846;

  // SIDEBIT 2

	public function getId():Int
	{
		return this;
	}

	public static function getMedalByLevel(levelId:String):Medal
	{
		switch (levelId)
		{
			default:
				return Unknown;
		}
	}
}
