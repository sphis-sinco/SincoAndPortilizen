package sap.outdated;

class OutdatedCheck
{
	public static var LINK:String = 'https://raw.githubusercontent.com/[USER]/[REPO]/refs/heads/[BRANCH]/[FILE].txt';

	public static var GIT_USER:String = 'sphis-Sinco';
	public static var GIT_REPO:String = 'SincoAndPortilizen';
	public static var GIT_BRANCH:String = #if debug 'main-indev' #else 'main' #end;
	public static var GIT_FILE:String = 'version';

	public static function checkForOutdatedVersion():Bool
	{
		final final_link:String = LINK.replace('[USER]', GIT_USER)
			.replace('[REPO]', GIT_REPO)
			.replace('[BRANCH]', GIT_BRANCH)
			.replace('[FILE]', GIT_FILE);

		var http = new haxe.Http(final_link);
		var returnedData:Array<String> = [];

		http.onData = function(data:String)
		{
			returnedData[0] = data.substring(0, data.indexOf(';'));
			returnedData[1] = data.substring(data.indexOf('-'), data.length);
			if (Global.VERSION_FULL.contains(returnedData[0].trim()))
				return false;

			trace('OUTDATED VERSION: ' + returnedData[0] + ' != ' + Global.VERSION_FULL);
			return true;
		}

		http.onError = function(error)
		{
			trace('error: $error');
		}

		http.request();

		return false;
	}
}
