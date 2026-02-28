package backend.translations;

import macohi.util.WindowUtil;

class Translate
{
	public static var DEFAULT_LANGUAGE_DATA:Language = null;
	public static var languageData:Language = DEFAULT_LANGUAGE_DATA;

	public static final DEFAULT_LANGUAGE:String = 'eng';

	public static function init()
	{
		DEFAULT_LANGUAGE_DATA = Assets.getJsonFile('languages/$DEFAULT_LANGUAGE');
		languageData = DEFAULT_LANGUAGE_DATA;
	}

	public static function getLanguage(language:String)
	{
		try
		{
			languageData = Assets.getJsonFile('languages/$language');
			FlxG.save.data.language = language;
		}
		catch (e)
		{
			WindowUtil.alert('Error Loading Language : $language', e.toString());

			languageData = DEFAULT_LANGUAGE_DATA;
			FlxG.save.data.language = DEFAULT_LANGUAGE;
		}
	}

	public static function getLine(line:String, ?replaces:Array<Dynamic>):String
	{
		var fallback:String = '{$line}';

		if (languageData == null)
			return fallback;

		var lineObject:Dynamic = languageData;

		for (piece in line.split('.'))
			lineObject = Reflect.field(lineObject, piece);

		if (lineObject == null)
			return fallback;

		var lineObjectStr:String = Std.string(lineObject);

		if (lineObjectStr == null)
			return fallback;

		if (replaces != null)
			for (i => replace in replaces)
				lineObject = lineObject.replace('%${i + 1}', replace);

		return lineObject;
	}
}
