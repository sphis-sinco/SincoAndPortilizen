package sap.stages.sidebit1;

class Sidebit1 extends State
{
        public static var DIFFICULTY:String;
        public static var DIFFICULTY_JSON:Sidebit1DifficultyJson;

        override public function new(difficulty:String) {
                super();
                
		DIFFICULTY = difficulty;
		DIFFICULTY_JSON = FileManager.getJSON(FileManager.getDataFile('stages/sidebit1/${difficulty}.json'));
        }

        override function create() {
                super.create();
        }

        override function update(elapsed:Float) {
                super.update(elapsed);
        }
}