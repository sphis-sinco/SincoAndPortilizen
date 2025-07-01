package sap.preload;

class DesktopPreloader extends State
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
        public var CTT:String = '${Global.GIT_VER} Desktop Preloader';
	public var currentTextureText:FlxText = new FlxText(10, 10, 0, '', 16);

	override function create()
	{
		super.create();

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

	public function texturePreload()
	{
		texturePreloadFinished = false;
		currentAssetIndex = 1;
		for (texturePath in assetsToPreload)
		{
			currentTexture = texturePath;
			trace('Preload progress: ' + '${(currentAssetIndex / assetsToPreload.length) * 100}% ' + '(${currentAssetIndex}/${assetsToPreload.length})');

			Global.cacheTexture(texturePath);

			currentAssetIndex++;
		}
		texturePreloadFinished = true;

                currentTextureText.text = CTT;
		if (Global.DEBUG_BUILD)
		{
			#if EXCESS_TRACES trace('Game is a debug build'); #end
                        currentTextureText.text += '\nPreloading complete! Press anything to start';
		}
	}
}
