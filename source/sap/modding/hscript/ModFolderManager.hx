package sap.modding.hscript;

class ModFolderManager
{
	public static var MODS:Array<String> = [];

	public static var MODS_FOLDER:String = 'mods/';

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
                                        #if EXCESS_TRACES
					trace('$folder is a valid mod');
					MODS.push(folder);
                                        #end
				}
			}
		}
                #else
                trace('Not sys. No mods');
                #end
	}
}
