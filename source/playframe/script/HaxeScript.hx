package playframe.script;

typedef HaxeModScript =
{
	var daPath:String;
	var daMod:String;
}

class HaxeScript
{
	public var daScript:HaxeModScript;
	public var fileName:String = "";
	public var mod:String = null;

	public static var haxeExts:Array<String> = ['hx', 'hscript'];

	public static var modsEnabled:Bool = true;

	public static var scriptPaths:Array<String> = [];

	public function new() {}

	public static function newFromPath(path):HaxeScript
	{
		var script = create(path);
		if (script != null)
		{
			script.loadFile(path);
			return script;
		}
		else
		{
			return null;
		}
	}

	public static function create(filePath:String):HaxeScript
	{
		var path = filePath;
		if (!scriptPaths.contains(filePath))
		{
			trace('Attempt at new HaxeScript: $filePath');
                        scriptPaths.push(filePath);
		}
		if (FileSystem.exists(path) && modsEnabled)
		{
			return new HScript();
		}
		return null;
	}

	public function executeFunc(funcName:String, ?args:Array<Any>):Dynamic
	{
		throw new Exception("Not Implemented!!");
		return null;
	}

	public function setVariable(name:String, val:Dynamic)
	{
		throw new Exception("Not Implemented!!");
	}

	public function getVariable(name:String):Dynamic
	{
		throw new Exception("Not Implemented!!");
		return null;
	}

	public function trace(text:String)
	{
		trace(text);
	}

	public function loadFile(path:String)
	{
		throw new Exception("Not Implemented!!");
	}

	public function destroy() {}
}
