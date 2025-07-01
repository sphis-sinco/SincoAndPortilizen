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
		
		for (texturePath in texturesToPreload)
		{
			currentTexture = texturePath;
			trace('Preload progress: ' + '${(currentAssetIndex / texturesToPreload.length) * 100}% ' + '(${currentAssetIndex}/${texturesToPreload.length})');

			Assets.loadBitmapData(texturePath);

			currentAssetIndex++;
		}
	}

}