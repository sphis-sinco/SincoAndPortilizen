package macohi.debugging;

// crash handler stuff
import haxe.Template;

using StringTools;
using macohi.util.StringUtil;

#if CRASH_HANDLER
import haxe.CallStack;
import haxe.io.Path;
import macohi.util.WindowUtil;
import openfl.Lib;
import openfl.events.UncaughtErrorEvent;
import sys.FileSystem;
import sys.io.File;
#end

/**
	This is to fix the annoying crashes with no
	response from haxeflixel unless in a debug build
**/
class CrashHandler
{
	public static var REPORT_PAGE:String = 'https://github.com/::github_user::/::github_repo::/issues';
	public static var FILE_LOCATION:String = 'crash';

	public static var FILE_PREFIX:String = 'Crash_';

	public static var GITHUB_USER:String = 'macohi';
	public static var GITHUB_REPO:String = '';

	public static function initalize(?new_file_location:String, ?new_file_prefix:String, ?new_github_user:String, ?new_github_repo:String)
	{
		if (!new_file_prefix.isBlankStr())
			FILE_PREFIX = new_file_prefix;

		if (!new_github_user.isBlankStr())
			GITHUB_USER = new_github_user;

		if (!new_github_repo.isBlankStr())
			GITHUB_REPO = new_github_repo;

		if (!new_file_location.isBlankStr())
			FILE_LOCATION = new_file_location;

		REPORT_PAGE = new Template(REPORT_PAGE).execute({
			'github_user': GITHUB_USER,
			'github_repo': GITHUB_REPO,
		});

		trace(' [CRASHHANDLER] Initalized CrashHandler');
		trace(' [CRASHHANDLER]  * FILE_PREFIX\t: $FILE_PREFIX');
		trace(' [CRASHHANDLER]  * REPORT_PAGE\t: $REPORT_PAGE');
		trace(' [CRASHHANDLER]  * GITHUB_USER\t: $GITHUB_USER');
		trace(' [CRASHHANDLER]  * GITHUB_REPO\t: $GITHUB_REPO');
		trace(' [CRASHHANDLER]  * FILE_LOCATION\t: $FILE_LOCATION');

		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end
	}

	/**
		Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine",
		big props to them!!!

		very cool person for real they don't get enough credit for their work
	**/
	#if CRASH_HANDLER
	public static function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String = './$FILE_LOCATION';
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		#if debug
		path += '-debug';
		#end

		path += '/$FILE_PREFIX$dateNow.txt';

		errMsg += "Uncaught Error: " + e.error + "\n\n";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + ":" + line + " \n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\nPlease report this error to the GitHub page: " + REPORT_PAGE;
		errMsg += "\n\n> Crash Handler originally written by: sqirra-rng";

		if (!FileSystem.exists("./" + FILE_LOCATION))
			FileSystem.createDirectory("./" + FILE_LOCATION);

		File.saveContent(path, errMsg + "\n");

		Sys.println('\n\nCRASH:\n');
		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		WindowUtil.alert("Error!", errMsg);
		Sys.exit(1);
	}
	#end
}