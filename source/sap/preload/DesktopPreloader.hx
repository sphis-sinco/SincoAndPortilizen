package sap.preload;

class DesktopPreloader extends PreloaderBase
{
	override public function new()
	{
		super();
		platform = 'Desktop';
		texturesToPreload = FileManager.getTypeArray('image', 'images', ['.png'], ['assets/cutscenes/images/']);
	}

	override public function texturePreload()
	{
		super.texturePreload();

		for (texturePath in texturesToPreload)
		{
			currentTexture = texturePath;
			var progress = '';
			var progress_percent = '';
			var msg:String = '';

			var msgFunc:(message:String, ?addToCTTFunc:Bool) -> Void = (message:String, ?addToCTTFunc:Bool) ->
			{
				progress = '(${currentAssetIndex - 1}/${texturesToPreload.length})';
				progress_percent = '${FlxMath.roundDecimal(((currentAssetIndex - 1) / texturesToPreload.length) * 100, 0)}%';
				#if EXCESS_TRACES
				trace('Preload progress: $progress_percent $progress');
				#end

				msg = message + ' $progress';
				#if EXCESS_TRACES
				trace(msg);
				#end
				if (addToCTTFunc)
					addToCTT(msg);
			}

			var getShortPath:(tpSplit:Array<String>) -> String = (tpSplit:Array<String>) ->
			{
				var path:String = '';

				for (item in tpSplit)
				{
					switch (item)
					{
						case 'assets', 'images', 'cutscenes':
							// NAH

						default:
							path += item + (item != tpSplit[tpSplit.length - 1] ? '/' : '');
					}
				}

				return path;
			}

			#if (target.threaded)
			addToCTT('${Global.getLocalizedPhrase('preloader-preloading', 'Preloading')}...');

			sys.thread.Thread.create(() ->
			{
				// trace('Caching $texturePath in a thread \n');

				Global.cacheTexture(texturePath, {
					onComplete: () ->
					{
						currentAssetIndex++;
						// if (currentAssetIndex > texturesToPreload.length)
						// 	currentAssetIndex--;
					},
					onFail: tpSplit ->
					{
						var shortpath = getShortPath(tpSplit);
						msgFunc('${Global.getLocalizedPhrase('preloader-preload-failed', 'is being preloaded')} ${shortpath}');
					},
					onSuccess: tpSplit ->
					{
						var shortpath = getShortPath(tpSplit);
						msgFunc('${shortpath} ${Global.getLocalizedPhrase('preloader-preload-succeedded', 'was preloaded')}');
					},
					onStart: tpSplit ->
					{
						var shortpath = getShortPath(tpSplit);
						msgFunc('${shortpath} ${Global.getLocalizedPhrase('preloader-preload-start', 'is being preloaded')}');
					}
				});
			});
			#else
			Global.cacheTexture(texturePath, {
				onComplete: () ->
				{
					currentAssetIndex++;
				}
			});
			#end
		}
	}
}
