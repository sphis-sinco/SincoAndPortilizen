package sap.preload;

class PreloaderBase extends State
{
	public var assetsToPreload:Array<String> = [
		FileManager.getImageFile('sidebit1/pre-sidebit1_sparrow', CUTSCENES),
		FileManager.getImageFile('sidebit1/pre-sidebit1_atlas/spritemap1', CUTSCENES),
		FileManager.getImageFile('sidebit1/post-sidebit1_atlas/spritemap1', CUTSCENES),
		FileManager.getImageFile('sidebit2/sidebit2-intro', CUTSCENES),
		FileManager.getImageFile('sidebit2/sidebit2-ending', CUTSCENES),
		FileManager.getImageFile('gameplay/sidebits/sidebit2_bg'),
		FileManager.getImageFile('gameplay/sinco stages/StageOneBackground'),
	];
	public var texturePreloadFinished:Bool = false;

	public var currentAssetIndex:Int = (Global.DEBUG_BUILD) ? -1 : 0;

	public var currentTexture:String = '';
        public var platform:String;
	public var CTT:String;
	public var currentTextureText:FlxText = new FlxText(10, 10, 0, '', 16);

	override function create()
	{
		super.create();

                CTT = '${Global.GIT_VER} ${platform} Preloader';

		currentTextureText.text = CTT;
		currentTextureText.fieldWidth = FlxG.width - (currentTextureText.x * 2);
		add(currentTextureText);

		currentTextureText.text += '\nPress anything to start preloading';
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.watch.addQuick('currentAssetIndex', currentAssetIndex);
		FlxG.watch.addQuick('currentTexture', currentTexture);

		if (texturePreloadFinished)
		{
			if (Global.keyJustReleased(ANY) && Global.DEBUG_BUILD)
				InitState.proceed();
			if (!Global.DEBUG_BUILD)
				InitState.proceed();
		}
		else if (currentAssetIndex == 0)
		{
			texturePreload();
		}
		else if (currentAssetIndex < 0)
		{
			if (Global.keyJustReleased(ANY))
				currentAssetIndex = 0;
		}
	}

	public function texturePreload() {}
}
