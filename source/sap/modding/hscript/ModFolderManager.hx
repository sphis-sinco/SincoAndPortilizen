package sap.modding.hscript;

class ModFolderManager
{
        public static var MODS:Array<String> = [];

        public static var MODS_FOLDER:String = 'mods/';

        public static function readModFolder():Void
        {
                // NO DUPES
                MODS = [];

                for (folder in FileManager.readDirectory(MODS_FOLDER))
                {
                        trace(folder);
                }
        }
}