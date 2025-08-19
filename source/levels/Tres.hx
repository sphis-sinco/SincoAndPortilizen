package levels;

class Tres extends PausableState
{
        public var sinco:Spr;
        public var port:Spr;

	override function create()
	{
		super.create();

                sinco = new Spr();
                sinco.loadGraphic(Assets.getImagePath('tres/superSinco'));
                sinco.screenCenter();
                sinco.x -= sinco.width;
                sinco.y -= sinco.height;
                add(sinco);

                port = new Spr();
                port.loadGraphic(Assets.getImagePath('tres/superPort'));
                port.screenCenter();
                port.x -= (port.width * 2);
                port.y += (port.height * 2);
                add(port);
	}
}
