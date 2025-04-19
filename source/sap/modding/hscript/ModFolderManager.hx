package sap.modding.hscript;

class ModFolderManager
{
	public static var ENABLED_MODS:Array<String> = [];
	public static var MODS:Array<String> = [];
	public static var DISABLED_MODS:Array<String> = [];

	public static var MODS_FOLDER:String = 'mods/';

	public static final SUPPORTED_MODDING_API_VERSIONS:Array<String> = [];

	public static function makeSupportedModdingApiVersions():Void
	{
		SUPPORTED_MODDING_API_VERSIONS.push('0.1.0');
		SUPPORTED_MODDING_API_VERSIONS.push('0.1.1');
		SUPPORTED_MODDING_API_VERSIONS.push('0.1.2');
		SUPPORTED_MODDING_API_VERSIONS.push('0.1.3');
		SUPPORTED_MODDING_API_VERSIONS.push('0.1.4');

		#if EXCESS_TRACES
		trace('Supported mod API versions: ');
		for (version in SUPPORTED_MODDING_API_VERSIONS)
		{
			trace('* ${version}');
		}
		#end
	}

	public static function readModFolder():Void
	{
		// NO DUPES
		ENABLED_MODS = [];
		MODS = [];
		DISABLED_MODS = [];

		#if sys
		for (folder in FileManager.readDirectory(MODS_FOLDER))
		{
			#if EXCESS_TRACES
			trace('${MODS_FOLDER}$folder');
			#end
			if (!folder.contains('.'))
			{
				#if EXCESS_TRACES
				trace('Potential mod folder: $folder');
				#end

				var dir:Array<String> = FileSystem.readDirectory('${MODS_FOLDER}${folder}/');

				#if EXCESS_TRACES
				trace(dir);
				#end
				if (dir.contains('meta.json'))
				{
					TryCatch.tryCatch(function()
					{
						readMetaData(folder);
					});
				}
			}
		}

		if (MODS.length > 0)
		{
			trace('Loaded ${MODS.length} mod${MODS.length > 1 ? 's' : ''}');
			for (mod in MODS)
			{
				trace('* ${modInfo(FileManager.getJSON('${MODS_FOLDER}${mod}/meta.json'))}');
			}

			sortModArrays();
			trace('ENABLED_MODS: ${ENABLED_MODS}');
			trace('DISABLED_MODS: ${DISABLED_MODS}');
		}
		#else
		trace('Not sys. No mods');
		#end
	}

	public static function disableMod(modName:String):Void
	{
		ENABLED_MODS.remove(modName);
		DISABLED_MODS.push(modName);

		sortModArrays();
	}

	public static function enableMod(modName:String):Void
	{
		DISABLED_MODS.remove(modName);
		ENABLED_MODS.push(modName);

		sortModArrays();
	}

	public static function toggleMod(modName:String):Void
	{
		if (ENABLED_MODS.contains(modName))
			disableMod(modName);
		else
			enableMod(modName);
	}

	public static function sortModArrays():Void
	{
		final sortFunc:String->String->Int = (s1, s2) -> Random.StringSortAlphabetically(s1, s2);

		ENABLED_MODS.sort(sortFunc);
		MODS.sort(sortFunc);
		DISABLED_MODS.sort(sortFunc);

		FlxG.save.data.enabled_mods = ENABLED_MODS;
		ScriptManager.loadScripts();
	}

	public static function neatModList():String
	{
		if (ENABLED_MODS.length == 0)
		{
			return 'No mods enabled\n';
		}

		var neat_list:String = '';

		for (Mod in ENABLED_MODS)
		{
			neat_list += '${modInfo(FileManager.getJSON('${MODS_FOLDER}${Mod}/meta.json'))}\n';
		}

		return neat_list;
	}

	public static function modInfo(dir_meta:ModMetaData, ?version:Bool = true, ?api_version:Bool = true):String
	{
		return '${dir_meta.name}' + '${(version) ? ' v${dir_meta.version}' : ''}' + '${(api_version) ? ' (api version: ${dir_meta.api_version})' : ''}';
	}

	private static function readMetaData(folder:String):Void
	{
		var dir_meta:ModMetaData = null;

		TryCatch.tryCatch(function()
		{
			dir_meta = FileManager.getJSON('${MODS_FOLDER}${folder}/meta.json');
		}, {
				errFunc: function()
				{
					dir_meta = null;
				}
		});

		if (dir_meta == null)
		{
			trace('Mod "${folder}" could not have the meta.json read, sorry');
		}
		else if (!SUPPORTED_MODDING_API_VERSIONS.contains(dir_meta.api_version))
		{
			trace('Mod "${dir_meta.name}" was built for incompatible API version (${dir_meta.api_version.toString()}), "${SUPPORTED_MODDING_API_VERSIONS[0]}" expected at minimum');
		}
		else
		{
			MODS.push(folder);
			if (SaveManager.getEnabledMods() != null)
			{
				if (!SaveManager.getEnabledMods().contains(folder))
				{
					DISABLED_MODS.push(folder);
				}
				else
				{
					ENABLED_MODS.push(folder);
				}
			}
			else
			{
				ENABLED_MODS.push(folder);
			}
		}
	}
}
