package sap.modding.hscript;

class ModFolderManager
{
	public static var MODS:Array<String> = [];

	public static var MODS_FOLDER:String = 'mods/';

	public static final MODDING_API_VERSION_RULE:String = ">=0.1.0 <0.2.0";

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
					if (!polymod.util.VersionUtil.match(dir_meta.api_version, MODDING_API_VERSION_RULE))
					{
						trace('Mod "${dir_meta.name}" was built for incompatible API version ${dir_meta.api_version.toString()}, expected "${MODDING_API_VERSION_RULE.toString()}"');
                                                break;
					}

					#if EXCESS_TRACES
					trace('$folder is a valid mod');
					#end
					MODS.push(folder);
				}
			}
		}

		trace('All mods: ${MODS}');
		#else
		trace('Not sys. No mods');
		#end
	}
}
