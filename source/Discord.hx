package;
#if DISCORDRPC
import Sys.sleep;
import discord_rpc.DiscordRpc;

/**
 * A class used to display a discord rpc status on a your discord profile while playing the game.
 */
class DiscordClient
{
        public static var CLIENT_ID:String = "1324111625682288720";

        static var startTimestamp:Float = Date.now().getTime();

	public function new()
	{

		trace("Discord Client starting...");
		DiscordRpc.start({
			clientID: "1324111625682288720",
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});
		trace("Discord Client started.");

		while (true)
		{
			DiscordRpc.process();
			sleep(2);
		}

		DiscordRpc.shutdown();
	}

	public static function shutdown()
	{
		DiscordRpc.shutdown();
	}

	static function onReady()
	{
		DiscordRpc.presence({
			details: "Starting the Game..",
			state: null,
			largeImageKey: 'icon',
			largeImageText: Global.VERSION
		});
	}

	static function onError(_code:Int, _message:String)
	{
		trace('Error! $_code : $_message');
	}

	static function onDisconnected(_code:Int, _message:String)
	{
		trace('Disconnected! $_code : $_message');
	}

	public static function initialize()
	{
		var DiscordDaemon = sys.thread.Thread.create(() ->
		{
			new DiscordClient();
		});
		trace("Discord Client initialized");
	}

	public static function changePresence(details:String, state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float)
	{
		DiscordRpc.presence({
			details: details,
			state: state,
			largeImageKey: 'icon',
			largeImageText: Global.VERSION,
			smallImageKey: smallImageKey,
			startTimestamp: Std.int(startTimestamp / 1000),
			endTimestamp: Std.int(startTimestamp + Date.now().getTime() / 1000)
		});
	}
}
#end