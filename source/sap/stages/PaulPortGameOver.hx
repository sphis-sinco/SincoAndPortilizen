package sap.stages;

import flxgif.FlxGifSprite;

class PaulPortGameOver extends State
{
	public static var thegif:FlxGifSprite;

	public static function init()
	{
                trace('thegif init');
		thegif = new FlxGifSprite();
		thegif.loadGif(FileManager.getImageFile('gameplay/port stages/portgameover').replace('png', 'gif'));
		thegif.screenCenter();
		thegif.antialiasing = true;

		thegif.player.loopEndHandler = function()
		{
                        thegif.visible = false;
		};
	}

	override function create()
	{
		super.create();

		add(thegif);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
