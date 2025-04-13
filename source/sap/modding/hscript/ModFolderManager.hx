package sap.modding.hscript;

class ModFolderManager
{
	public static var MODS:Array<String> = [];

	public static var MODS_FOLDER:String = 'mods/';

	public static final SUPPORTED_MODDING_API_VERSIONS:Array<String> = [];

	public static function makeSupportedModdingApiVersions():Void
	{
		SUPPORTED_MODDING_API_VERSIONS.push('0.1.0');
	}

	public static function readModFolder():Void
	{
		// NO DUPES
		MODS = [];

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
					var dir_meta:ModMetaData = FileManager.getJSON('${MODS_FOLDER}${folder}/meta.json');
					if (!SUPPORTED_MODDING_API_VERSIONS.contains(dir_meta.api_version))
					{
						trace('Mod "${dir_meta.name}" was built for incompatible API version (${dir_meta.api_version.toString()}), "${SUPPORTED_MODDING_API_VERSIONS[0]}" expected at minimum');
					}
					else
					{
						MODS.push(folder);
					}
				}
			}
		}

		trace('Loaded ${MODS.length} mod${MODS.length > 1 ? 's' : ''}');
		for (mod in MODS)
		{
			var dir_meta:ModMetaData = FileManager.getJSON('${MODS_FOLDER}${mod}/meta.json');
			trace('* ${dir_meta.name} v${dir_meta.version} (api version: ${dir_meta.api_version})');
		}
		#else
		trace('Not sys. No mods');
		#end
	}
}
