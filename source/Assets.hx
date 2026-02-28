import haxe.Json;

class Assets
{
	public static var IMAGE_EXT:String = 'png';

	public static var VIDEO_EXT:String = 'mp4';

	public static var SOUND_EXT:String = 'wav';

	// file paths

	public static function getPath(id:String):String
	{
		return id;
	}

	public static function getAssetPath(id:String):String
		return getPath('assets/$id');

	public static function getDataPath(id:String):String
		return getAssetPath('data/$id');

	public static function getImagePath(id:String):String
		return getAssetPath('images/$id.$IMAGE_EXT');

	public static function getVideoPath(id:String):String
		return getAssetPath('videos/$id.$VIDEO_EXT');

	public static function getMusicPath(id:String):String
		return getAssetPath('music/$id.$SOUND_EXT');

	public static function getSoundPath(id:String):String
		return getAssetPath('sounds/$id.$SOUND_EXT');

	public static function getImage(id:String, ?imageFolder:Bool = true)
	{
		var path = getAssetPath('$id.$IMAGE_EXT');
		if (imageFolder)
			path = getImagePath(id);

		return openfl.Assets.getBitmapData(path);
	}

	public static function getFileTextContent(id:String, ?dataFolder:Bool = true):String
	{
		var path = getAssetPath('$id');
		if (dataFolder)
			path = getDataPath('$id');

		return lime.utils.Assets.getText(path);
	}

	public static function getTextFile(id:String, ?dataFolder:Bool = true):String
		return getFileTextContent('$id.txt', dataFolder);

	public static function getFileJsonContent(id:String, ?dataFolder:Bool = true):Dynamic
		return Json.parse(getFileTextContent(id, dataFolder));

	public static function getJsonFile(id:String, ?dataFolder:Bool = true):Dynamic
		return getFileJsonContent('$id.json', dataFolder);
}
