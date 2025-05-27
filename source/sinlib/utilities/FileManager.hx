package sinlib.utilities;

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
	public static var FILE_MANAGER_VERSION:Float = 9.8;

	/**
	 * This would be used because a project modifies the file for their own purposes
	 */
	public static var FILE_MANAGER_VERSION_SUFFIX:String = '';

	public static function getVersion():String
	{
		return FILE_MANAGER_VERSION + FILE_MANAGER_VERSION_SUFFIX;
	}

	public static var UNLOCALIZED_ASSETS:Array<String> = [];
	public static var UNFOUND_ASSETS:Array<String> = [];

	public static var LOCALIZED_ASSET_SUFFIX:String = '';

	/**
	 * Returns a path
	 * @param pathprefix Prefix which most likely is `assets/`
	 * @param path File
	 * @param PATH_TYPE Assets folder
	 * @return String
	 */
	public static function getPath(pathprefix:String, path:String, ?PATH_TYPE:PathTypes = DEFAULT, ?posinfo:PosInfos):String
	{
		var ogreturnpath:String = '${pathprefix}${PATH_TYPE}${path}';
		var returnpath:String = ogreturnpath;

		#if !DISABLE_LOCALIZED_ASSETS
		var asset_suffix:String = LOCALIZED_ASSET_SUFFIX;
		final suffix:String = (asset_suffix.length > 0) ? '-${LOCALIZED_ASSET_SUFFIX}' : '';
		var localizedreturnpath:String = '${ogreturnpath.split('.')[0]}${suffix}.${ogreturnpath.split('.')[1]}';

		if (localizedreturnpath != returnpath)
		{
			if (exists(localizedreturnpath))
			{
				returnpath = localizedreturnpath;
			}
			else
			{
				if (!UNLOCALIZED_ASSETS.contains(localizedreturnpath))
				{
					#if CNGLA_TRACES trace('Could not get localized asset: $localizedreturnpath'); #end
					UNLOCALIZED_ASSETS.push(localizedreturnpath);
				}
			}
		}
		#end

		if (exists(returnpath))
		{
			#if EXCESS_TRACES trace('Existing asset return path: ${returnpath}'); #end
			return returnpath;
		}

		unfoundAsset(returnpath, posinfo);
		return '';
	}

	public static inline function unfoundAsset(asset:String, ?posinfo:PosInfos):Void
	{
		if (!UNFOUND_ASSETS.contains(asset))
		{
			if (asset.contains('mods/'))
			{
				#if EXCESS_TRACES
				trace('Could not get asset: $asset'); // , posinfo);
				#end
			}
			else
			{
				trace('Could not get asset: $asset'); // , posinfo);
			}
			UNFOUND_ASSETS.push(asset);
		}
	}

	/**
	 * Returns an `assets/$file`
	 * @param file File
	 * @param PATH_TYPE Assets folder
	 * @return String
	 */
	public static function getAssetFile(file:String, ?PATH_TYPE:PathTypes = DEFAULT, ?posinfo:PosInfos):String
	{
		var returnPath:String = '';

		for (mod in ModFolderManager.ENABLED_MODS)
		{
			// What if I was evil and made it so that 0.1.0 api mods couldnt do this >:)
			var dir_meta:ModMetaData = FileManager.getJSON('${ModFolderManager.MODS_FOLDER}${mod}/meta.json', posinfo);

			if (returnPath == '') // first come first serve
			{
				returnPath = getPath('mods/$mod/', '$file', PATH_TYPE, posinfo); // 'mods/$mod/$file'
			}
		}

		if (returnPath == '')
		{
			returnPath = getPath('assets/', '$file', PATH_TYPE, posinfo); // 'assets/$file'
		}

		return returnPath;
	}

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
	public static function getScriptFile(file:String, ?PATH_TYPE:PathTypes = DEFAULT, ?posinfo:PosInfos):String
	{
		var finalPath:Dynamic = 'scripts/$file'; // .$SCRIPT_EXT';

		#if SCRIPT_FILES_IN_DATA_FOLDER
		return getDataFile(finalPath, PATH_TYPE, posinfo);
		#end

		return getAssetFile(finalPath, PATH_TYPE, posinfo);
	}

	#if sys
	public static function getScriptArray():Array<String>
	{
		var arr:Array<String> = [];
		var scriptPaths:Array<String> = ['assets/scripts/'];
		var scriptExtensions:Array<String> = ['.hx', '.hxc'];

		var readFolder:Dynamic = function(folder:String, ogdir:String) {};

		var readFileFolder:Dynamic = function(folder:String, ogdir:String)
		{
			#if EXCESS_TRACES
			trace('${ogdir}${folder}');
			#end

			for (file in readDirectory('${ogdir}${folder}'))
			{
				final endsplitter:String = '${!folder.endsWith('/') && !file.startsWith('/') ? '/' : ''}';
				for (extension in scriptExtensions)
				{
					if (file.endsWith(extension))
					{
						final path:String = '${ogdir}${folder}${endsplitter}${file}';

						if (!arr.contains(path))
						{
							arr.push('${path}');
						}
					}
				}

				if (!file.contains('.'))
				{
					readFolder('${file}', '${ogdir}${folder}${endsplitter}');
				}
			}
		}

		readFolder = function(folder:String, ogdir:String)
		{
			#if EXCESS_TRACES
			trace('reading ${ogdir}${folder}');
			#end

			TryCatch.tryCatch(function()
			{
				if (!folder.contains('.'))
				{
					readFileFolder(folder, '${ogdir}');
				}
				else
				{
					readFileFolder(ogdir, '');
				}
			}, {
					traceErr: true
			});
		}
		var readDir:Dynamic = function(directory:String)
		{
			#if EXCESS_TRACES
			trace('reading ${directory}');
			#end
			for (folder in FileSystem.readDirectory(directory))
			{
				readFolder(folder, directory);
			}
		}

		for (folder in ModFolderManager.ENABLED_MODS)
		{
			#if EXCESS_TRACES
			trace('Checking $folder for a scripts folder');
			#end
			final folder_read:Array<String> = readDirectory('${ModFolderManager.MODS_FOLDER}${folder}/');

			if (folder_read.contains('scripts'))
			{
				#if EXCESS_TRACES
				trace('$folder has a scripts folder');
				#end
				scriptPaths.push('${ModFolderManager.MODS_FOLDER}${folder}/scripts/');
			}
		}

		for (path in scriptPaths)
		{
			#if EXCESS_TRACES
			trace('reading scriptPath: $path');
			#end
			readDir(path);
		}

		var traceArr:Array<String> = [];
		for (path in arr)
		{
			var split = path.split('/');
			traceArr.push(split[split.length - 1]);
		}

		trace('Loaded script files: ${traceArr}');
		return arr;
	}
	#else
	public static function getScriptArray():Array<String>
	{
		trace('Not Sys!');
		return [];
	}
	#end
	#else

	/**
	 * Dummy var for if not `SCRIPT_FILES`
	 */
	public static var SCRIPT_EXT:String = '';

	/**
	 * Dummy function for if not `SCRIPT_FILES`
	 */
	public static function getScriptFile(?file:String = '', ?PATH_TYPE:PathTypes = DEFAULT, ?posinfo:PosInfos):String
	{
		return '';
	}

	/**
	 * Dummy function for if not `SCRIPT_FILES`
	 */
	public static function getScriptArray():Array<String>
	{
		return [];
	}
	#end

	/**
	 * Returns `assets/data/$file`
	 * @param file File
	 * @param PATH_TYPE Assets folder
	 * @return String
	 */
	public static function getDataFile(file:String, ?PATH_TYPE:PathTypes = DEFAULT, ?posinfo:PosInfos):String
		return getAssetFile('data/$file', PATH_TYPE, posinfo);

	/**
	 * Returns `assets/images/$file.png`
	 * @param file File
	 * @param PATH_TYPE Assets folder
	 * @return String
	 */
	public static function getImageFile(file:String, ?PATH_TYPE:PathTypes = DEFAULT, ?posinfo:PosInfos):String
		return getAssetFile('images/$file.png', PATH_TYPE, posinfo);

	/**
	 * Returns `assets/$file.$SOUND_EXT`
	 * @param file File
	 * @param PATH_TYPE Assets folder
	 * @return String
	 */
	public static function getSoundFile(file:String, ?PATH_TYPE:PathTypes = DEFAULT, ?posinfo:PosInfos):String
	{
		return getAssetFile('$file.$SOUND_EXT', PATH_TYPE, posinfo);
	}

	/**
	 * Writes to a file or path using `sys`
	 * @param path File path
	 * @param content File content
	 */
	public static function writeToPath(path:String, content:String):Void
	{
		#if sys
		if (path.length > 0)
		{
			File.saveContent(path, content);
		}
		else
		{
			throw 'A path is required.';
		}
		#else
		trace('NOT SYS!');
		#end
	}

	/**
	 * Read a file using `lime.utils.Assets` and a try catch function
	 * @param path the path of the file your trying to read
	 */
	public static function readFile(path:String, ?posinfo:PosInfos):String
	{
		if (!exists(path))
		{
			unfoundAsset(path, posinfo);
			return '';
		}

		#if sys
		TryCatch.tryCatch(function()
		{
			return File.getContent(path);
		}, {
				traceErr: true
		});
		#end

		TryCatch.tryCatch(function()
		{
			return Assets.getText(path);
		}, {
				traceErr: true
		});

		return '';
	}

	/**
	 * Reads a file that SHOULD BE A JSON, using `readFile`
	 * @param path the path of the json your trying to get
	 */
	public static function getJSON(path:String, ?posinfo:PosInfos):Dynamic
	{
		var json:Dynamic = null;

		TryCatch.tryCatch(function()
		{
			json = TJSON.parse(readFile(path, posinfo));
		}, {
				errFunc: function()
				{
					json = readFile(path, posinfo);
				}
		});

		return json;
	}

	/**
	 * Reads a directory if `sys` via `FileSystem.readDirectory`
	 * @param dir This is the directory being read
	 */
	public static function readDirectory(dir:String, ?typeArr:Array<String>):Array<String>
	{
		var finalList:Array<String> = [];
		var rawList:Array<String> = [];

		#if sys
		rawList = FileSystem.readDirectory(dir);
		for (i in 0...rawList.length)
		{
			if (typeArr?.length > 0)
			{
				for (type in typeArr)
				{
					if (rawList[i].endsWith(type))
					{
						finalList.push(rawList[i]);
					}
				}
			}
			else
				finalList.push(rawList[i]);
		}

		return finalList;
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

	public static function getPackerAtlas(path:String, ?path_type:PathTypes, ?posinfo:PosInfos):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(getImageFile(path, path_type, posinfo), getImageFile('$path', path_type, posinfo).replace('.png', '.txt'));
	}

	public static function getSparrowAtlas(path:String, ?path_type:PathTypes, ?posinfo:PosInfos)
	{
		return FlxAtlasFrames.fromSparrow(getImageFile(path, path_type, posinfo), getImageFile('$path', path_type, posinfo).replace('.png', '.xml'));
	}
}

/**
 * This would hold Asset folders, for example `assets/default` or `assets/gameplay`
 */
enum abstract PathTypes(String) from String to String
{
	public var DEFAULT:String = '';
	public var CUTSCENES:String = 'cutscenes/';
	public var STICKERS:String = 'stickers/';
}
