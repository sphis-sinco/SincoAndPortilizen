package sap.preload;

class WebPreloader extends PreloaderBase
{
	override public function new() {
		super();
		platform = 'Web';
	}

        override public function texturePreload()
	{
		super.texturePreload();
		
		for (texturePath in assetsToPreload)
		{
			currentTexture = texturePath;
			trace('Preload progress: ' + '${(currentAssetIndex / assetsToPreload.length) * 100}% ' + '(${currentAssetIndex}/${assetsToPreload.length})');

			Assets.loadBitmapData(texturePath);

			currentAssetIndex++;
		}
	}

}