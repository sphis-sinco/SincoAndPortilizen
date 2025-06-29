package sap.stages.sidebit2;

class Sidebit2 extends PausableState
{
        public static var DIFFICULTY:String = 'normal';
	public static var DIFFICULTY_JSON:Sidebit2DifficultyJson;

        override public function new(difficulty:String = 'normal') {
                super(false);

		DIFFICULTY = difficulty;
		DIFFICULTY_JSON = FileManager.getJSON(FileManager.getDataFile('stages/sidebit2/${difficulty}.json'));
        }

        override function create() {
                super.create();
        }

        override function postCreate() {
                super.postCreate();
        }

        override function update(elapsed:Float) {
                super.update(elapsed);

                if (Global.keyJustReleased(ESCAPE))
		{
			togglePaused();
		}
        }
        
}