package sap.stages.stage5;

class Stage5 extends State
{
        public static var DIFFICULTY:String = 'normal';        

	override public function new(difficulty:String)
	{
		super();

                DIFFICULTY = difficulty;
	}

	override function create()
	{
		super.create();

		Global.changeDiscordRPCPresence('Stage 5 (${DIFFICULTY.toUpperCase()}): Rival Clash', null);
	}

	override function postCreate()
	{
		super.postCreate();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
