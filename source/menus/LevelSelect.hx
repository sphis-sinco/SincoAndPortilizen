package menus;

class LevelSelect extends FlxState
{
	override function create()
	{
                Global.changeDiscordRPCPresence('In the Level Select', null);

		add(Global.dummyBG([226, 226, 226]));

		super.create();
	}
}
