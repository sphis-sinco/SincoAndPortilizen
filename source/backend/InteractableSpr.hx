package backend;

import flixel.util.FlxSignal;
import flixel.math.FlxPoint;

class InteractableSpr extends Spr
{
	public var desiredPosition:FlxPoint = new FlxPoint();

	public var unoverlap:FlxSignal = new FlxSignal();
	public var overlap:FlxSignal = new FlxSignal();
	public var overlapped:Bool = false;

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
		if (FlxG.mouse.overlaps(this) && FlxG.mouse.enabled)
		{
			scale.set(scale.x - .1, scale.y - .1);
			overlapped = true;
			overlap.dispatch();
		}
		else
		{
			if (overlapped)
			{
				overlapped = false;
				unoverlap.dispatch();
			}

			scaleSpr();
		}

		if (FlxG.mouse.pressed && FlxG.mouse.overlaps(this) && FlxG.mouse.enabled)
			pressed.dispatch();
		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(this) && FlxG.mouse.enabled)
			justPressed.dispatch();
		if (FlxG.mouse.released && FlxG.mouse.overlaps(this) && FlxG.mouse.enabled)
			released.dispatch();

		if (FlxG.mouse.justReleased && FlxG.mouse.overlaps(this) && FlxG.mouse.enabled)
		{
			justReleased.dispatch();
			if (justReleased_soundPlay)
				Global.playSoundEffect('blipSelect');
		}
	}
}
