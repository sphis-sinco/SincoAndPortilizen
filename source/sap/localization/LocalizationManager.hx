package sap.localization;

class LocalizationManager
{
	public static var LANGUAGE:String = 'english';
	public static var LANGUAGE_SWAP_LIST:Map<String, String> = [
                'english' => 'spanish',
                'spanish' => 'portuguese',
                'portuguese' => 'english'
        ];
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
		"menu-settings" => "settings",
		"play-new" => "new",
		"play-continue" => "continue",
		"play-back" => "back",
		"settings-language" => "language",
		"settings-volume" => "volume",
		"settings-window-resolution" => "window resolution"
	];

	public static dynamic function changeLanguage()
	{
		trace('Trying to change to languge: $LANGUAGE');

		TEXT_CONTENT = returnLanguageTEXT_CONTENT();

		if (TEXT_CONTENT == default_text_content && LANGUAGE != 'english')
		{
			ASSET_SUFFIX = '';
			trace('Failed to change to language: $LANGUAGE');
			LANGUAGE = 'english';
		}
		else
		{
			trace('Succeeded to change to language: $LANGUAGE');
		}

                FileManager.LOCALIZED_ASSET_SUFFIX = ASSET_SUFFIX;
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
                                "menu-settings" => "ajustes",
				"play-new" => "nuevo",
				"play-continue" => "continuar",
				"play-back" => "atrás",
                                "settings-language" => "idioma",
                                "settings-volume" => "volumen",
                                "settings-window-resolution" => "resolución de ventana"
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
                                "menu-settings" => "configurações",
				"play-new" => "novo",
				"play-continue" => "continuar",
				"play-back" => "voltar",
                                "settings-language" => "linguagem",
                                "settings-volume" => "volume",
                                "settings-window-resolution" => "resolução da janela"
			];
		}

                TryCatch.tryCatch(() -> {
                        ASSET_SUFFIX = ScriptSupport.custom_language_assetsuffixes.get(LANGUAGE);
                        return ScriptSupport.custom_language_content.get(LANGUAGE);
                });

		ASSET_SUFFIX = '';
		return default_text_content;
	}

        public static dynamic function swapLanguage()
        {
                LANGUAGE = LANGUAGE_SWAP_LIST.get(LANGUAGE);
                changeLanguage();
        }
}
