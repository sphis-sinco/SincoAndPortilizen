package sap.preload;

class PreloaderBase extends State
{
	// TODO: JSON this, add credits, blah blah blah, also add animation support
	public var preloadArts:Array<String> = [#if html5 'web/w(e)eber' #end];
	public var preloadArt:FlxSprite = new FlxSprite();

	public var texturesToPreload:Array<String> = [
		FileManager.getImageFile('sidebit1/pre-sidebit1_sparrow', CUTSCENES),
		FileManager.getImageFile('sidebit1/pre-sidebit1_atlas/spritemap1', CUTSCENES),
		FileManager.getImageFile('sidebit1/post-sidebit1_atlas/spritemap1', CUTSCENES),
		FileManager.getImageFile('sidebit2/sidebit2-intro', CUTSCENES),
		FileManager.getImageFile('sidebit2/sidebit2-ending', CUTSCENES),
		FileManager.getImageFile('gameplay/sidebits/sidebit2_bg'),
		FileManager.getImageFile('gameplay/sinco stages/StageOneBackground'),
	];
	public var texturePreloadFinished:Bool = false;

	public var soundsToPreload:Array<String> = [];
	public var soundPreloadFinished:Bool = false;

	public var PreloadFinished:Bool = false;

	public var currentAssetIndex:Int = -1;

	public var currentTexture:String = '';
	public var platform:String;
	public var CTT:String;
	public var currentTextureText:FlxText = new FlxText(10, 10, 0, '', 16);

	override function create()
	{
		super.create();

		CTT = '${Global.GIT_VER} ${Global.getLocalizedPhrase('preloader-${platform.toLowerCase()}-preloader', '${platform} Preloader')}';

		currentTextureText.text = CTT;
		currentTextureText.fieldWidth = FlxG.width - (currentTextureText.x * 2);
		add(currentTextureText);

		addToCTT('Press anything (except R) to start preloading');

		#if desktop
		preloadArts = [];

		for (file in FileManager.getTypeArray('preloader image', 'images/preloader/', ['.png'], ['assets/images/preloader/']))
		{
			if (!file.contains('web/') && !file.contains('keoiki'))
				preloadArts.push(file.split('/')[file.split('/').length - 1].replace('.png', ''));
		}
		trace('Preloader artwork names: $preloadArts');
		#end

		if (FlxG.random.bool(1 / 100000))
			preloadArts = ['keoiki'];

		randomPreloadArt();
		add(preloadArt);

		// stickerTransitionClear();
	}

	public function randomPreloadArt()
	{
		var art:String = preloadArts[FlxG.random.int(0, preloadArts.length - 1)];

		preloadArt.loadGraphic(FileManager.getImageFile('preloader/$art'));
		preloadArt.screenCenter();

		if (!art.endsWith('-px'))
			preloadArt.antialiasing = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.watch.addQuick('currentAssetIndex', currentAssetIndex);
		FlxG.watch.addQuick('currentTexture', currentTexture);

		if (PreloadFinished)
		{
			if (Global.keyJustReleased(ANY) && !Global.keyJustReleased(R) && Global.DEBUG_BUILD)
				InitState.proceed();
			if (!Global.DEBUG_BUILD)
				InitState.proceed();
		}
		else if (currentAssetIndex == 0)
		{
			if (!texturePreloadFinished)
				texturePreload();
			else if (!soundPreloadFinished)
				soundPreload();
		}
		else if (currentAssetIndex < 0)
		{
			if (Global.keyJustReleased(ANY) && !Global.keyJustReleased(R))
				currentAssetIndex = 0;
		}

		if (Global.keyJustReleased(R))
			randomPreloadArt();

		if (!texturePreloadFinished && currentAssetIndex > texturesToPreload.length)
			texturePreloadFinished = true;
		if (!soundPreloadFinished && currentAssetIndex > soundsToPreload.length)
			soundPreloadFinished = true;

		PreloadFinished = texturePreloadFinished && soundPreloadFinished;

		if (PreloadFinished)
		{
			if (Global.DEBUG_BUILD && !currentTextureText.text.contains('!'))
			{
				addToCTT('Preloading complete! Press anything (except R) to start');
			}
		}
	}

	public function texturePreload()
	{
		texturePreloadFinished = false;
		currentAssetIndex = 1;
	}

	public function soundPreload()
	{
		soundPreloadFinished = false;
		currentAssetIndex = 1;
	}

	public function addToCTT(text:String)
	{
		currentTextureText.text = CTT;
		currentTextureText.text += '\n$text';
	}
}
