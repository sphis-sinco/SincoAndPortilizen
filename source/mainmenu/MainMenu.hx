package mainmenu;

class MainMenu extends FlxState
{
	var sinco:MenuCharacter = new MenuCharacter(0,0,"Sinco");
	var port:MenuCharacter = new MenuCharacter(0,0,"Portilizen");

	override function create()
	{
		sinco.screenCenter();
		port.screenCenter();

		sinco.x -= sinco.width;
		port.x += port.width;

		add(sinco);
		add(port);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}