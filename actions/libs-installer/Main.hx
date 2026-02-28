import haxe.Json;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class Main
{
	public static function main():Void
	{
		if (!FileSystem.exists('.haxelib'))
			FileSystem.createDirectory('.haxelib');

		var libraries:Array<String> = File.getContent('libraries.bat').split('\n');

		for (lib in libraries)
		{
			Sys.command(lib.trim());
		}

		Sys.exit(0);
	}
}
