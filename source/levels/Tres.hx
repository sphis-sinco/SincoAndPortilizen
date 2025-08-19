package levels;

import flixel.math.FlxPoint;

class Tres extends PausableState
{
	public var sinco:Spr;
	public var port:Spr;

        public var sincoSCPos:FlxPoint;
        public var portSCPos:FlxPoint;

        public var sincoRPos:FlxPoint;
        public var portRPos:FlxPoint;

	public var selectedHero:Int = 0;

	override function create()
	{
		super.create();

		sinco = new Spr();
		sinco.loadGraphic(Assets.getImagePath('tres/superSinco'));
		sinco.screenCenter();
                sincoSCPos = new FlxPoint(sinco.x, sinco.y);
		sinco.x -= sinco.width;
		sinco.y -= sinco.height;
		add(sinco);
                sincoRPos = new FlxPoint(sinco.x, sinco.y);

		port = new Spr();
		port.loadGraphic(Assets.getImagePath('tres/superPort'));
		port.screenCenter();
                portSCPos = new FlxPoint(port.x, port.y);
		port.x -= (port.width * 2);
		port.y += (port.height * 2);
		add(port);
                portRPos = new FlxPoint(port.x, port.y);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

                switch(selectedHero)
                {
                        case 0:
                                sinco.x += ((sincoSCPos.x - sinco.x) / 10);
                                sinco.y += ((sincoSCPos.y - sinco.y) / 10);
                                port.x += ((portRPos.x - port.x) / 10);
                                port.y += ((portRPos.y - port.y) / 10);
                        case 1:
                                sinco.x += ((sincoRPos.x - sinco.x) / 10);
                                sinco.y += ((sincoRPos.y - sinco.y) / 10);
                                port.x += ((portSCPos.x - port.x) / 10);
                                port.y += ((portSCPos.y - port.y) / 10);
                }

                if (Global.keyJustReleased(Z))
                        selectedHero = (selectedHero == 1) ? 0 : 1;
	}
}
