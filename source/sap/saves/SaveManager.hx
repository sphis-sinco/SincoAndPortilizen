package sap.saves;

import haxe.Json;

class SaveManager
{
        public static var save_data:SaveInformation;

        public static function resetSaveData() {
                save_data = new SaveInformation();

                save_data.gameplaystatus = {
                        levels_complete: []
                };

                save_data.language = "english";

                save_data.results = {
                        grade: "F",
                        rank: "awful"
                }
        }

        public static function saveSettings() {
                FileManager.writeToPath('save.json', Json.stringify(save_data));
	}

        public static function loadPrefs() {
                save_data = FileManager.getJSON(FileManager.getPath('', 'save.json'));
                trace(save_data);
        }
}