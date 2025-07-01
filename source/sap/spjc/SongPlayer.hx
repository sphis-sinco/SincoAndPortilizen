package sap.spjc;

import sap.title.TitleState;

typedef SongSettings =
{
	var path:String;
	var songname:String;
	var ?composors:String;
}

class SongPlayer
{
	public static var CURRENT_SONG:String = '';

	public static var playingFlxText:FlxText;

	public static function playSong(filename:String = '', ?volume:Float = 1.0, ?loop:Bool = false)
	{
		var play:Void->Void = () ->
		{
			var filepath = FileManager.getSoundFile('music/$filename');
			final filepath_exists = FileManager.exists(filepath);
			final filepath_json = filepath.replace('.wav', '.json');
			final filepath_json_exists = FileManager.exists(filepath_json);

			if (!filepath_exists && filepath_json_exists)
			{
				var songJson:SongSettings = FileManager.getJSON(filepath_json);
				if (songJson.composors == null)
					songJson.composors = 'Unknown';

				if (songJson.songname != CURRENT_SONG)
				{
					trace('Could get asset: $filepath_json');
					CURRENT_SONG = songJson.songname;
					var playingText = 'Playing ${songJson.songname} by ${songJson.composors}';
					trace(playingText);

					playingFlxText = new FlxText(0, 0, 0, playingText, 16);
					playingFlxText.screenCenter(X);
					playingFlxText.y = FlxG.height - playingFlxText.height - 16;
					playingFlxText.color = FlxColor.WHITE;

					switch (Global.getCurrentState())
					{
						case 'TitleState':
							playingFlxText.y -= 64;
							playingFlxText.color = FlxColor.BLACK;
						case 'Stage4':
							playingFlxText.y = 16;
					}

					FlxTween.tween(playingFlxText, {alpha: 0}, 2, {
						startDelay: 2,
						onComplete: tween ->
						{
							FlxG.state.remove(playingFlxText);
							playingFlxText.destroy();
						}
					});

					FlxG.state.add(playingFlxText);
				}

				filepath = FileManager.getSoundFile('music/${songJson.path}');
			}

			FlxG.sound.playMusic(filepath, volume, loop);
		};

		play();
	}
}
