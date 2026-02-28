package sphis;

import flixel.*;
import flixel.system.FlxModding;
import haxe.Json;
import sphis.defines.*;

class Assets
{
	/**
	 * The common extension for image files
	 */
	public static var IMAGE_EXT:String = 'png';

	/**
	 * The common extension for video files
	 */
	public static var VIDEO_EXT:String = 'mp4';

	/**
	 * The common extension for wav files
	 */
	public static var SOUND_EXT:String = 'wav';

	/**
	 * The common extension for hscript script files
	 */
	public static var HSCRIPT_EXT:String = 'hxc';

	// file paths

	/**
	 * Return a path to a file.
	 		 * 
	 		 * If you have the `flixel-modding` library installed,
	 		 * You can compile with a define: `flixelModding` (project XML or not doesn't matter obviously)
	 		 * and it will automatically attempt to redirect the path to a
	 		 * path in a mod using `FlxModding.system.redirect`
	 		 * 
	 * @param id The path to the file
	 * @return String The returning path (probably parsed into a valid path)
	 */
	public static function getPath(id:String):String
	{
		if (DefineManager.enabledDefine('flixelModding') && FlxModding.enabled)
		{
			@:privateAccess {
				FlxG.log.notice('getPath($id)');
				return FlxModding.system.sanitize(id);
			}
		}
		else
			return id;
	}

	/**
	 * Returns a path in the `assets` folder
	 */
	public static function getAssetPath(id:String):String
		return getPath('assets/$id');

	/**
	 * Returns a path in the `assets/data` folder
	 */
	public static function getDataPath(id:String):String
		return getAssetPath('data/$id');

	/**
	 * Returns a path in the `assets/images` folder
	 */
	public static function getImagePath(id:String):String
		return getAssetPath('images/$id.$IMAGE_EXT');

	/**
	 * Returns a path in the `assets/videos` folder
	 */
	public static function getVideoPath(id:String):String
		return getAssetPath('videos/$id.$VIDEO_EXT');

	/**
	 * Returns a path in the `assets/music` folder
	 */
	public static function getMusicPath(id:String):String
		return getAssetPath('music/$id.$SOUND_EXT');

	/**
	 * Returns a path in the `assets/sounds` folder
	 */
	public static function getSoundPath(id:String):String
		return getAssetPath('sounds/$id.$SOUND_EXT');

	// file content

	/**
	 * Returns the bitmap data of an image
	 * (modified by `flixelModding` define)
	 * 
	 * @param id image path
	 * @param imageFolder this controls if you wana look inisde `assets` or  `assets/images`
	 */
	public static function getImage(id:String, ?imageFolder:Bool = true)
	{
		var path = getAssetPath('$id.$IMAGE_EXT');
		if (imageFolder)
			path = getImagePath(id);

		if (DefineManager.enabledDefine('flixelModding') && FlxModding.enabled)
			return FlxModding.system.assetSystem.getBitmapData(path);
		else
			return openfl.Assets.getBitmapData(path);
	}

	/**
	 * Returns the text content of a file with text content
	 * (modified by `flixelModding` define)
	 		 * 
	 * @param id file path
	 * @param dataFolder this controls if you wana look inisde `assets` or  `assets/data`
	 */
	public static function getFileTextContent(id:String, ?dataFolder:Bool = true):String
	{
		var path = getAssetPath('$id');
		if (dataFolder)
			path = getDataPath('$id');

		if (DefineManager.enabledDefine('flixelModding') && FlxModding.enabled)
			return FlxModding.system.assetSystem.getText(path);
		else
			return lime.utils.Assets.getText(path);
	}

	/**
	 * Returns the text content of a `.txt` file
	 * (modified by `flixelModding` define)
	 		 * 
	 * @param id text file path
	 * @param dataFolder this controls if you wana look inisde `assets` or  `assets/data`
	 */
	public static function getTextFile(id:String, ?dataFolder:Bool = true):String
		return getFileTextContent('$id.txt', dataFolder);

	/**
	 * Returns the json of a file with json content
	 * (modified by `flixelModding` define)
	 		 * 
	 * @param id file path
	 * @param dataFolder this controls if you wana look inisde `assets` or  `assets/data`
	 */
	public static function getFileJsonContent(id:String, ?dataFolder:Bool = true):Dynamic
		return Json.parse(getFileTextContent(id, dataFolder));

	/**
	 * Returns the json content of a json file
	 * (modified by `flixelModding` define)
	 		 * 
	 * @param id json file path
	 * @param dataFolder this controls if you wana look inisde `assets` or  `assets/data`
	 */
	public static function getJsonFile(id:String, ?dataFolder:Bool = true):Dynamic
		return getFileJsonContent('$id.json', dataFolder);
}
