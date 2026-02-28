import macohi.funkin.koya.backend.AssetPaths;
import macohi.funkin.koya.backend.KoyaAssets;
import haxe.Json;

class Assets
{
	public static function getImage(id:String, ?imageFolder:Bool = true)
	{
		var path = getAssetPath('$id.$IMAGE_EXT');
		if (imageFolder)
			path = getImagePath(id);

		return openfl.Assets.getBitmapData(path);
	}

	public static function getFileTextContent(id:String):String
	{
		var path = getAssetPath('$id');
		if (dataFolder)
			path = getDataPath('$id');

		return lime.utils.Assets.getText(path);
	}

	public static function getTextFile(id:String):String
		return KoyaAssets.getText(AssetPaths.json('data/$id'));

	public static function getJsonFile(id:String):Dynamic
		return Json.parse(getTextFile(id));
}
