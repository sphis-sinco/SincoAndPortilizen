package sap.preload;

class WebPreloader extends PreloaderBase
{
	override public function new() {
		super();
		platform = 'Web';
	}

        override public function texturePreload()
	{
		texturePreloadFinished = false;
		currentAssetIndex = 1;
		for (texturePath in assetsToPreload)
		{
			currentTexture = texturePath;
			trace('Preload progress: ' + '${(currentAssetIndex / assetsToPreload.length) * 100}% ' + '(${currentAssetIndex}/${assetsToPreload.length})');

			Assets.loadBitmapData(texturePath);

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