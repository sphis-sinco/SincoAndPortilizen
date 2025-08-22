package source; // Yeah, I know...

import sys.io.File;

/**
 * A script which executes before the game is built.
 */
class Prebuild
{
	static final NG_CREDS_PATH:String = './source/backend/newgrounds/Credentials.hx';

	static final NG_CREDS_TEMPLATE:String = "package backend.newgrounds;

/**
 * Put this in `source/backend/newgrounds` if for some reason you're compiling with the `NEWGROUNDS` flag
 * Or use `NEWGROUNDS_GIT`.
 */

class Credentials
{
	public static var APP_ID:String = '';
	public static var SESSION_ID:String = null;
	public static var BACKUP_SESSION_ID:String = null;
	public static var ENCRYPTION_KEY:String = '';
}
";

	static function main():Void
	{
		var start:Float = Sys.time();
		trace('[PREBUILD] Performing pre-build tasks...');

		buildCredsFile();

		var end:Float = Sys.time();
		var duration:Float = end - start;
		trace('[PREBUILD] Finished pre-build tasks in $duration seconds.');
	}

	static function buildCredsFile():Void
	{
		if (sys.FileSystem.exists(NG_CREDS_PATH))
		{
			trace('[PREBUILD] Credentials.hx already exists, skipping.');
		}
		else
		{
			trace('[PREBUILD] Creating Credentials.hx...');

			var fileContents:String = NG_CREDS_TEMPLATE;

			sys.io.File.saveContent(NG_CREDS_PATH, fileContents);
		}
	}
}
