package sap.stages.stage5;

class Stage5 extends State
{
	override public function new(difficulty:String)
	{
		super();
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
