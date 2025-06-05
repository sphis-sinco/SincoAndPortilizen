package sap.localization;

class Locale
{
	public static var languageJson:Dynamic = {};
	public static var localeName:String = '';

	public static function initalizeLocale(language:String):Void
	{
		final localeSave:Dynamic = languageJson;

		languageJson = Json.parse(FileManager.readFile(FileManager.getDataFile('locale/$language.json')));

		if (languageJson == null)
		{
			throw 'Could not get the "$language" locale JSON (perhaps a mispelling?)';
			languageJson = localeSave;
		}
		else
		{
			localeName = Reflect.getProperty(languageJson, 'internalname');

			if (localeName == null)
			{
				trace('The "$language" locale does not have the "internalname" field.');

				localeName = language;
			}

			final localeAssetSuffix:String = Reflect.getProperty(languageJson, 'asset-path');

			if (localeAssetSuffix == null)
				FileManager.LOCALIZED_ASSET_SUFFIX = '';
			else
				FileManager.LOCALIZED_ASSET_SUFFIX = localeAssetSuffix;
		}
	}

	public static function getPhrase(field:String, fallback:String):String
	{
		if (Reflect.field(languageJson, field) != null)
			return Reflect.field(languageJson, field);
		else
		{
			trace('The current locale does not have the "$field" field.');

			var returnFallback = fallback;
			return returnFallback ??= '';
		}
	}
}
