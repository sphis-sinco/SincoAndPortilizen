package sap.modding.source;

class ModListManager {
        /**
         * List of mod files
         */
        public static var modList:Array<ModBasic> = [];

        /**
         * Adds a mod to `modList`
         * @param newmod the mod your adding
         */
        public static function addMod(newmod:ModBasic):Void
        {
                modList.push(newmod);
        }
}