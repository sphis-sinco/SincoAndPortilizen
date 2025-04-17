package sap.worldmap;

class CharacterSelect extends State
{
        public static var CHARACTER_LIST:Array<String> = [];

        override public function new() {
                super();

                CHARACTER_LIST = [];
                for (file in FileManager.readDirectory('assets/data/playable_characters'))
                {
                        CHARACTER_LIST.push(file.split('.')[0]);
                }
        }

	override function create()
	{
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
