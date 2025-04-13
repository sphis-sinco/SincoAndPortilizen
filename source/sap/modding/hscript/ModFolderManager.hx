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
                        trace(folder);
			if (FileSystem.isDirectory(folder))
			{
				trace('Mod folder: $folder');

                                var dir:Array<String> = FileSystem.readDirectory('${MODS_FOLDER}${folder}/');

                                trace(dir);
				if (dir.contains('meta.json'))
				{
					trace('$folder is a valid mod');
					MODS.push(folder);
				}
			}
		}
                #else
                trace('Not sys. No mods');
                #end
	}
}
