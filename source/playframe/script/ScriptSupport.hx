package playframe.script;

class ScriptSupport
{
	public static function setScriptDefaultVars(script:HaxeScript, mod:String, settings:Dynamic)
	{
		var superVar = {};
		if (Std.isOfType(script, HScript))
		{
			var hscript:HScript = cast script;
			for (k => v in hscript.hscript.variables)
			{
				Reflect.setField(superVar, k, v);
			}
		}
		script.setVariable("super", superVar);
		script.setVariable("mod", mod);
		script.setVariable("import", function(className:String)
		{
			var splitClassName = [for (e in className.split(".")) e.trim()];
			var realClassName = splitClassName.join(".");
			var cl = Type.resolveClass(realClassName);
			var en = Type.resolveEnum(realClassName);
			if (cl == null && en == null)
			{
				trace('Class / Enum at $realClassName does not exist.');
			}
			else
			{
				if (en != null)
				{
					var enumThingy = {};
					for (c in en.getConstructors())
					{
						Reflect.setField(enumThingy, c, en.createByName(c));
					}
					script.setVariable(splitClassName[splitClassName.length - 1], enumThingy);
				}
				else
				{
					// CLASS!!!!
					script.setVariable(splitClassName[splitClassName.length - 1], cl);
				}
			}
		});

		script.setVariable("trace", function(text)
		{
			try
			{
				script.trace(text);
			}
			catch (e)
			{
				trace(e);
			}
		});
		var curState:Dynamic = FlxG.state;
		script.setVariable("add", function(obj)
		{
			curState.add(obj);
		});
		script.setVariable("remove", function(obj)
		{
			curState.remove(obj);
		});
		script.setVariable("insert", function(pos, obj)
		{
			curState.insert(pos, obj);
		});

		script.setVariable("FlxSprite", FlxSprite);
		script.setVariable("FlxG", FlxG);
		script.setVariable("FlxState", FlxState);
		script.setVariable("Std", Std);
		script.setVariable("Math", Math);
		script.setVariable("FlxMath", FlxMath);
		script.setVariable("ScriptSupport", ScriptSupport); // ?
		script.setVariable("StringTools", StringTools);
		script.setVariable("FlxSound", FlxSound);
		script.setVariable("FlxEase", FlxEase);
		script.setVariable("FlxTween", FlxTween);
		script.setVariable("FlxBackdrop", FlxBackdrop);
		script.setVariable("FlxTypedGroup", FlxTypedGroup);
		script.setVariable("FlxTimer", FlxTimer);
		script.setVariable("FlxText", FlxText);
		script.setVariable("FlxTextBorderStyle", FlxTextBorderStyle);
		script.setVariable("FileManager", FileManager);
		script.setVariable("FlxAtlasFrames", FlxAtlasFrames);

		script.setVariable('FlxPoint', new FlxPoint());
		script.setVariable('SparrowSprite', SparrowSprite);
		script.setVariable('PostStage1Cutscene', PostStage1Cutscene);

		script.setVariable('FileManager', FileManager);

		script.setVariable('ResultsMenu', ResultsMenu);
		script.setVariable('StageGlobals', StageGlobals);
		script.setVariable('Worldmap', Worldmap);

		script.setVariable("Global", Global);

		script.setVariable("switchState", function(nextState:NextState)
		{
			FlxG.switchState(nextState);
		});

		script.mod = mod;
	}

	public static function getExprFromPath(path:String, critical:Bool = false):hscript.Expr
	{
		var parser = new hscript.Parser();
		parser.allowTypes = true;
		var ast:Expr = null;
		try
		{
			#if sys
			ast = parser.parseString(sys.io.File.getContent(path));
			#else
			trace("No sys support detected.");
			#end
		}
		catch (ex)
		{
			trace(ex);
			var ext = Std.string(ex);
			var line = parser.line;
			var gay:String = 'An error occured while parsing the file located at "$path".\r\n$ext at $line';
			if (!openfl.Lib.application.window.fullscreen)
				openfl.Lib.application.window.alert(gay);
			trace(gay);
		}
		return ast;
	}
}
