import openfl.display.Sprite;
import sinlib.SLGame;

class Main extends Sprite
{
	public function new()
	{
		super();

		// Set the saveslot to a debug saveslot or a release saveslot
		Global.change_saveslot((SLGame.isDebug) ? 'debug' : 'release');
                
                #if DISCORDRPC
		Discord.DiscordClient.initialize();
                #end

                
		addChild(new FlxGame(0, 0, InitState));
	}
}
