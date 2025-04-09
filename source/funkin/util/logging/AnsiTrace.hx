package funkin.util.logging;

class AnsiTrace
{
	public static var TRACE_LIST:Array<String> = [];
	public static var MAX_TRACES:Int = 30;

	/**
	 * Output a message to the log.
	 * Called when using `trace()`, and modified from the default to support ANSI colors.
	 * @param v The value to print.
	 */
	public static function trace(v:Dynamic, ?info:haxe.PosInfos)
	{
		TRACE_LIST.push('${Global.posInfoString(info).replace('/', '.').replace('source/', '')}: ${v}');

		#if (NO_FEATURE_LOG_TRACE)
		return;
		#end
		var str = formatOutput(v, info);
		#if FEATURE_DEBUG_TRACY
		cpp.vm.tracy.TracyProfiler.message(str, flixel.util.FlxColor.WHITE);
		#end
		#if js
		if (js.Syntax.typeof(untyped console) != "undefined" && (untyped console).log != null)
			(untyped console).log(str);
		#elseif lua
		untyped __define_feature__("use._hx_print", _hx_print(str));
		#elseif sys
		Sys.println(str);
		#else
		throw new haxe.exceptions.NotImplementedException()
		#end
	}

	public static var colorSupported:Bool = #if sys (Sys.getEnv("TERM") == "xterm" || Sys.getEnv("ANSICON") != null) #else false #end;

	// ansi stuff
	public static inline var RED = "\x1b[31m";
	public static inline var YELLOW = "\x1b[33m";
	public static inline var WHITE = "\x1b[37m";
	public static inline var NORMAL = "\x1b[0m";
	public static inline var BOLD = "\x1b[1m";
	public static inline var ITALIC = "\x1b[3m";

	/**
	 * Format the output to use ANSI colors.
	 * Edited from the standard `trace()` implementation.
	 */
	public static function formatOutput(v:Dynamic, infos:haxe.PosInfos):String
	{
		var str = Std.string(v);
		if (infos == null)
			return str;

		if (colorSupported)
		{
			var dirs:Array<String> = infos.fileName.split("/");
			dirs[dirs.length - 1] = ansiWrap(dirs[dirs.length - 1], BOLD);

			// rejoin the dirs
			infos.fileName = dirs.join("/");
		}

		var pstr = infos.fileName + ":" + ansiWrap(infos.lineNumber, BOLD);
		if (infos.customParams != null)
			for (v in infos.customParams)
				str += ", " + Std.string(v);
		return pstr + ": " + str;
	}

	public static function ansiWrap(str:Dynamic, ansiCol:String)
	{
		return ansify(ansiCol) + str + ansify(NORMAL);
	}

	public static function ansify(ansiCol:String)
	{
		return (colorSupported ? ansiCol : "");
	}
}
