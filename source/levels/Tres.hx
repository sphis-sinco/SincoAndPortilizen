package levels;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;

class Tres extends PausableState
{
	public var sinco:Spr;
	public var port:Spr;

	public var sincoSCPos:FlxPoint;
	public var portSCPos:FlxPoint;

	public var sincoRPos:FlxPoint;
	public var portRPos:FlxPoint;

	public var sincoPlayerPos:FlxPoint;
	public var portPlayerPos:FlxPoint;

	public var portParticles:FlxTypedGroup<Spr>;

	public var selectedHero:Int = 0;

	override function create()
	{
		super.create();

		portParticles = new FlxTypedGroup<Spr>();
		add(portParticles);

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

		sincoPlayerPos = new FlxPoint();
		portPlayerPos = new FlxPoint();
	}

	final playerSpeed:Float = 10;
	final setPosSpeed:Float = 10;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		switch (selectedHero)
		{
			case 0:
				sinco.x += (((sincoSCPos.x + sincoPlayerPos.x) - sinco.x) / setPosSpeed);
				sinco.y += (((sincoSCPos.y + sincoPlayerPos.y) - sinco.y) / setPosSpeed);
				port.x += ((portRPos.x - port.x) / setPosSpeed);
				port.y += ((portRPos.y - port.y) / setPosSpeed);
			case 1:
				sinco.x += ((sincoRPos.x - sinco.x) / setPosSpeed);
				sinco.y += ((sincoRPos.y - sinco.y) / setPosSpeed);
				port.x += (((portSCPos.x + portPlayerPos.x) - port.x) / setPosSpeed);
				port.y += (((portSCPos.y + portPlayerPos.y) - port.y) / setPosSpeed);
		}

		if (Global.keyJustReleased(Z))
		{
			sincoPlayerPos = new FlxPoint();
			portPlayerPos = new FlxPoint();

			selectedHero = (selectedHero == 1) ? 0 : 1;
		}

		movementCheck();

		if (FlxG.random.bool(FlxG.random.float(80, 100)))
		{
			var particle = new Spr(-3);

			particle.loadGraphic(Assets.getImagePath('tres/superPortParticles'), true, 32, 32);
			particle.animation.add('particles', [0, 1, 2, 3], 0);
			particle.animation.randomFrame();

			particle.scaleSpr();

			particle.setPosition(port.getGraphicMidpoint().x, port.getGraphicMidpoint().y);

			portParticles.add(particle);
		}

		for (particle in portParticles)
		{
			particle.x += ((port.getGraphicMidpoint().x - particle.x) / (setPosSpeed / 2));
			particle.y += ((port.getGraphicMidpoint().y - particle.y) / (setPosSpeed / 2));

			particle.x -= FlxG.random.float((particle.height / 10), particle.height * 2);
			particle.y += FlxG.random.float(-(particle.height / 4), particle.height / 4);

			particle.alpha -= (1 / FlxG.random.float(1, 15));

			if (particle.alpha <= 0)
			{
				portParticles.members.remove(particle);
				particle.destroy();
			}
		}
	}

	public function movementCheck()
	{
		if (Global.anyKeysPressed([LEFT, A]))
		{
			switch (selectedHero)
			{
				case 0:
					sincoPlayerPos.x -= playerSpeed;
				case 1:
					portPlayerPos.x -= playerSpeed;
			}
		}

		if (Global.anyKeysPressed([RIGHT, D]))
		{
			switch (selectedHero)
			{
				case 0:
					sincoPlayerPos.x += playerSpeed;
				case 1:
					portPlayerPos.x += playerSpeed;
			}
		}

		if (Global.anyKeysPressed([UP, W]))
		{
			switch (selectedHero)
			{
				case 0:
					sincoPlayerPos.y -= playerSpeed;
				case 1:
					portPlayerPos.y -= playerSpeed;
			}
		}

		if (Global.anyKeysPressed([DOWN, S]))
		{
			switch (selectedHero)
			{
				case 0:
					sincoPlayerPos.y += playerSpeed;
				case 1:
					portPlayerPos.y += playerSpeed;
			}
		}

		var playerPos = sincoPlayerPos;
		if (selectedHero == 1)
			playerPos = portPlayerPos;

		var bindLeft = -(FlxG.width / 2);
		var bindUp = -(FlxG.height / 2);
		var bindDown = FlxG.height / 2;
		var bindRight = FlxG.width / 8;

		if (playerPos.x >= bindRight)
			playerPos.x = bindRight;
		if (playerPos.x <= bindLeft)
			playerPos.x = bindLeft;

		if (playerPos.y >= bindDown)
			playerPos.y = bindDown;
		if (playerPos.y <= bindUp)
			playerPos.y = bindUp;
	}
}
