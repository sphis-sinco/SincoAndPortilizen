package;

import haxe.Json;
import lime.utils.Assets;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class FileManager
{
	public static var SOUND_EXT:String = 'wav';

	/**
		this is the amount of times ive used this script
		and changed it a bit in which the changes can be used in other games.

		SYNTAX: `major`.`minor`
			
		@param major 
			it has some BIG changes like a new way of managing files... 
			new way of returning them. ETC. 	
			Also this is just what I said earlier. 
			the amount of times ive used this script and changed it a bit in which the changes can be used in other games.
		@param minor 
			small changes to the specific major version. 
			MAYBE there is now a feature flag required to be specified for specific functions to function. 
			I mean these can be big too but yknow. 1 thing at a time.
	 */
	public static var FILE_MANAGER_VERSION:Float = 8.0;

	public static function getPath(pathprefix:String, path:String, ?PATH_TYPE:PathTypes = DEFAULT):String
		return '${pathprefix}${PATH_TYPE}${path}';

	public static function getAssetFile(file:String, ?PATH_TYPE:PathTypes = DEFAULT):String
		return getPath('assets/', '$file', PATH_TYPE); // 'assets/default/$file

	#if SCRIPT_FILES
	public static var SCRIPT_EXT:String = 'lb1';

	public static function getScriptFile(file:String, ?PATH_TYPE:PathTypes = DEFAULT):String
	{
		var finalPath:Dynamic = 'scripts/$file.$SCRIPT_EXT';

		#if SCRIPT_FILES_IN_DATA_FOLDER
		return getDataFile(finalPath, PATH_TYPE);
		#end

		return getAssetFile(finalPath, PATH_TYPE);
	}
	#else
	public static var SCRIPT_EXT:String = '';

	public static function getScriptFile(?file:String = "", ?PATH_TYPE:PathTypes = DEFAULT):String
	{
		return "";
	}
	#end

	public static function getDataFile(file:String, ?PATH_TYPE:PathTypes = DEFAULT):String
		return getAssetFile('data/$file', PATH_TYPE);

	public static function getImageFile(file:String, ?PATH_TYPE:PathTypes = DEFAULT):String
		return getAssetFile('images/$file.png', PATH_TYPE);

	public static function getSoundFile(file:String, ?PATH_TYPE:PathTypes = DEFAULT):String
		return getAssetFile('$file.$SOUND_EXT', PATH_TYPE);

	public static function writeToPath(path:String, content:String)
	{
		#if sys
		if (path.length > 0)
			File.saveContent(path, content);
		else
			throw 'A path is required.';
		#else
		trace('NOT SYS!');
		#end
	}

	public static function readFile(path:String)
	{
		try
		{
			return Assets.getText(path);
		}
		catch (e)
		{
			#if sys
			trace(e);
			Sys.exit(0);
			return '';
			#else
			throw e;
			return '';
			#end
		}
	}

	public static function getJSON(path:String)
	{
		return Json.parse(readFile(path));
	}

	public static function readDirectory(dir:String)
	{
		#if sys
		return FileSystem.readDirectory(dir);
		#end

		return null;
	}
}

enum abstract PathTypes(String) from String to String
{
	public var DEFAULT:String = "";
}