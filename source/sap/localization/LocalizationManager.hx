package sap.localization;

class LocalizationManager
{
	public static var LANGUAGE:String = 'english';
	public static var ASSET_SUFFIX:String = '';

	public static var TEXT_CONTENT:Map<String, String> = [];

	public static var default_text_content:Map<String, String> = [
		"hp" => "HP",
		"dodge" => "DODGE",
		"rank-perfect" => "perfect",
		"rank-excellent" => "excellent",
		"rank-great" => "great",
		"rank-good" => "good",
		"rank-bad" => "bad",
		"rank-awful" => "awful",
		"you-did" => "YOU DID",
		"menu-play" => "play",
		"menu-credits" => "credits",
		"menu-leave" => "leave",
		"play-new" => "new",
		"play-continue" => "continue",
		"play-back" => "back"
	];

	public static dynamic function swapLanguage()
	{
		trace('Trying to swap to languge: $LANGUAGE');

		TEXT_CONTENT = returnLanguageTEXT_CONTENT();

		if (TEXT_CONTENT == default_text_content && LANGUAGE != 'english')
		{
                        LANGUAGE = 'english';
                        ASSET_SUFFIX = '';
			trace('Failed to swap to language: $LANGUAGE');
		}
		else
		{
			trace('Succeeded to swap to language: $LANGUAGE');
		}
	}

	public static dynamic function returnLanguageTEXT_CONTENT():Map<String, String>
	{
		if (LANGUAGE == 'spanish')
		{
			ASSET_SUFFIX = 'es';
			return [
				"hp" => "SALUD",
				"dodge" => "ESQUIVAR",
				"rank-perfect" => "perfecto",
				"rank-excellent" => "excelente",
				"rank-great" => "un gran trabajo",
				"rank-good" => "Bueno",
				"rank-bad" => "malo",
				"rank-awful" => "horrible",
				"you-did" => "LO HICISTE",
				"menu-play" => "jugar",
				"menu-credits" => "créditos",
				"menu-leave" => "dejar",
				"play-new" => "nuevo",
				"play-continue" => "continuar",
				"play-back" => "atrás"
			];
		}

		if (LANGUAGE == 'portuguese')
		{
			ASSET_SUFFIX = 'pt';
			return [
				"hp" => "HP",
				"dodge" => "DESVIE",
				"rank-perfect" => "perfeito",
				"rank-excellent" => "excelente",
				"rank-great" => "ótimo",
				"rank-good" => "bom",
				"rank-bad" => "ruim",
				"rank-awful" => "horrível",
				"you-did" => "VOCÊ FOI",
				"menu-play" => "jogar",
				"menu-credits" => "créditos",
				"menu-leave" => "sair",
				"play-new" => "novo",
				"play-continue" => "continuar",
				"play-back" => "voltar"
			];
		}

		ASSET_SUFFIX = '';
		return default_text_content;
	}
}
