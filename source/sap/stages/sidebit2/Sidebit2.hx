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

        public static var PLAYER:Sidebit2Character;
        public static var OPPONENT:Sidebit2Character;

        override function create() {
                super.create();

                PLAYER = new Sidebit2Character('port');
                OPPONENT = new Sidebit2Character('osin');

                PLAYER.setPosition(-200, 250);
                OPPONENT.setPosition(250, 128);

                add(OPPONENT);
                add(PLAYER);
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

                PLAYER.animation.paused = paused;
                OPPONENT.animation.paused = paused;
        }
        
}