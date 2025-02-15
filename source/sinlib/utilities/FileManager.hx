package sinlib.utilities;

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
	public static var FILE_MANAGER_VERSION:Float = 9.3;

	/**
	 * Returns a path
	 * @param pathprefix Prefix which most likely is `assets/`
	 * @param path File
	 * @param PATH_TYPE Assets folder
	 * @return String
	 */
	public static function getPath(pathprefix:String, path:String, ?PATH_TYPE:PathTypes = DEFAULT):String
	{
		var ogreturnpath:String = '${pathprefix}${PATH_TYPE}${path}';
		var returnpath:String = ogreturnpath;
                var returnpathAlt:String;

		TryCatch.tryCatch(() ->
		{
                        returnpathAlt = '${returnpath.split('.')[0]}-${PhraseManager.languageList.asset_suffix}.${returnpath.split('.')[1]}';

                        if (exists(returnpathAlt))
			{
                                // trace(returnpathAlt);
				returnpath = returnpathAlt;
			}
		}, {
				// traceErr: true,
                                errFunc: () -> {
                                        returnpath = ogreturnpath;
                                }
		});

		return returnpath;
	}

	/**
	 * Returns an `assets/$file`
	 * @param file File
	 * @param PATH_TYPE Assets folder
	 * @return String
	 */
	public static function getAssetFile(file:String, ?PATH_TYPE:PathTypes = DEFAULT):String
		return getPath('assets/', '$file', PATH_TYPE); // 'assets/default/$file

	#if SCRIPT_FILES
	/**
	 * File extension for scripts
	 */
	public static var SCRIPT_EXT:String = 'lb1';

	/**
	 * Returns `assets/data/scripts/$file` if `SCRIPT_FILES_IN_DATA_FOLDER` otherwise returns `assets/scripts/$file` only if `SCRIPT_FILES` is enabled
	 * @param file File
	 * @param PATH_TYPE Assets folder
	 * @return String
	 */
	public static function getScriptFile(file:String, ?PATH_TYPE:PathTypes = DEFAULT):String
	{
		var finalPath:Dynamic = 'scripts/$file.$SCRIPT_EXT';

		#if SCRIPT_FILES_IN_DATA_FOLDER
		return getDataFile(finalPath, PATH_TYPE);
		#end

		return getAssetFile(finalPath, PATH_TYPE);
	}
	#else

	/**
	 * Dummy var for if not `SCRIPT_FILES`
	 */
	public static var SCRIPT_EXT:String = '';

	/**
	 * Dummy function for if not `SCRIPT_FILES`
	 */
	public static function getScriptFile(?file:String = "", ?PATH_TYPE:PathTypes = DEFAULT):String
	{
		return "";
	}
	#end

	/**
	 * Returns `assets/data/$file`
	 * @param file File
	 * @param PATH_TYPE Assets folder
	 * @return String
	 */
	public static function getDataFile(file:String, ?PATH_TYPE:PathTypes = DEFAULT):String
		return getAssetFile('data/$file', PATH_TYPE);

	/**
	 * Returns `assets/images/$file.png`
	 * @param file File
	 * @param PATH_TYPE Assets folder
	 * @return String
	 */
	public static function getImageFile(file:String, ?PATH_TYPE:PathTypes = DEFAULT):String
		return getAssetFile('images/$file.png', PATH_TYPE);

	/**
	 * Returns `assets/$file.$SOUND_EXT`
	 * @param file File
	 * @param PATH_TYPE Assets folder
	 * @return String
	 */
	public static function getSoundFile(file:String, ?PATH_TYPE:PathTypes = DEFAULT):String
		return getAssetFile('$file.$SOUND_EXT', PATH_TYPE);

	/**
	 * Writes to a file or path using `sys`
	 * @param path File path
	 * @param content File content
	 */
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

	/**
	 * Read a file using `lime.utils.Assets` and a try catch function
	 * @param path the path of the file your trying to read
	 */
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

	/**
	 * Reads a file that SHOULD BE A JSON, using `readFile`
	 * @param path the path of the json your trying to get
	 */
	public static function getJSON(path:String)
	{
		return Json.parse(readFile(path));
	}

	/**
	 * Reads a directory if `sys` via `FileSystem.readDirectory`
	 * @param dir This is the directory being read
	 */
	public static function readDirectory(dir:String)
	{
		#if sys
		return FileSystem.readDirectory(dir);
		#end

		return null;
	}

        
        /**
         * Returns a bool value if `path` exists
         * @param path the path your checking
         * @return Bool
         */
        public static function exists(path:String):Bool
        {
                return openfl.utils.Assets.exists(path);
        }
}

/**
 * This would hold Asset folders, for example `assets/default` or `assets/gameplay`
 */
enum abstract PathTypes(String) from String to String
{
	public var DEFAULT:String = "";
}
