package backend;

import flixel.util.FlxSignal;
import flixel.math.FlxPoint;

class InteractableSpr extends Spr
{
	public var desiredPosition:FlxPoint = new FlxPoint();

	public var pressed:FlxSignal = new FlxSignal();
	public var justPressed:FlxSignal = new FlxSignal();
	public var released:FlxSignal = new FlxSignal();
	public var justReleased:FlxSignal = new FlxSignal();

	public var justReleased_soundPlay:Bool = true;

	override public function new(assetname:String)
	{
		super();
		loadGraphic(Assets.getImagePath(assetname));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		scaleSpr();
		setPosition(desiredPosition.x, desiredPosition.y);
		if (FlxG.mouse.overlaps(this))
			scale.set(scale.x - .1, scale.y - .1)
		else
			scaleSpr();

		if (FlxG.mouse.pressed && FlxG.mouse.overlaps(this))
			pressed.dispatch();
		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(this))
			justPressed.dispatch();
		if (FlxG.mouse.released && FlxG.mouse.overlaps(this))
			released.dispatch();

		if (FlxG.mouse.justReleased && FlxG.mouse.overlaps(this))
		{
			if (justReleased_soundPlay)
				Global.playSoundEffect('blipSelect');

			justReleased.dispatch();
		}
	}
}
