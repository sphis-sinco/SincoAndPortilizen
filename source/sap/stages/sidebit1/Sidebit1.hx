package sap.stages.sidebit1;

class Sidebit1 extends State
{
        public static var BACKGROUND_SKY:FlxSprite;
        public static var BACKGROUND_FLOOR:FlxSprite;

        public static var DIFFICULTY:String;
        public static var DIFFICULTY_JSON:Sidebit1DifficultyJson;

        override public function new(difficulty:String) {
                super();
                
		DIFFICULTY = difficulty;
		DIFFICULTY_JSON = FileManager.getJSON(FileManager.getDataFile('stages/sidebit1/${difficulty}.json'));
                trace('Sidebit 1 (${DIFFICULTY})');
        }

        override function create() {
                super.create();

                BACKGROUND_SKY = new FlxSprite();
                BACKGROUND_SKY.makeGraphic(FlxG.width, FlxG.height);
                BACKGROUND_SKY.screenCenter(XY);
                add(BACKGROUND_SKY);

                BACKGROUND_FLOOR = new FlxSprite();
                BACKGROUND_FLOOR.makeGraphic(FlxG.width, 64, 0xB5B5B5);
                BACKGROUND_FLOOR.screenCenter(X);
                BACKGROUND_FLOOR.y = (FlxG.height - BACKGROUND_FLOOR.height);
                add(BACKGROUND_FLOOR);
        }

        override function update(elapsed:Float) {
                super.update(elapsed);
        }
}