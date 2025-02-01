package mainmenu;

import flixel.util.FlxColor;

class MainMenu extends FlxState
{
	var sinco:MenuCharacter = new MenuCharacter(0,0,"Sinco");
	var port:MenuCharacter = new MenuCharacter(0,0,"Portilizen");
	var gridbg:FlxSprite = new FlxSprite();
	var menuselectbox:FlxSprite = new FlxSprite();

	override function create()
	{
		gridbg.loadGraphic(FileManager.getImageFile('mainmenu/MainMenuGrid'));
		add(gridbg);
		gridbg.scale.set(Global.DEFAULT_IMAGE_SCALE_MULTIPLIER, Global.DEFAULT_IMAGE_SCALE_MULTIPLIER);
		gridbg.screenCenter();

		sinco.screenCenter();
		port.screenCenter();

		sinco.x -= sinco.width * 1.5;
		port.x += port.width * 1.5;

		add(sinco);

		port.flipX = true;
		add(port);

		menuselectbox.makeGraphic(64, 64, FlxColor.BLACK);
		menuselectbox.scale.set(Global.DEFAULT_IMAGE_SCALE_MULTIPLIER, Global.DEFAULT_IMAGE_SCALE_MULTIPLIER);
		menuselectbox.screenCenter();
		add(menuselectbox);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}