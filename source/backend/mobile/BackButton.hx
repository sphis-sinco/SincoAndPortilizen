package backend.mobile;

import flixel.math.FlxPoint;

class BackButton extends InteractableSpr
{
	public var positionOffset:FlxPoint;

	override public function new(returnState:FlxState, mypositionOffset:FlxPoint = null)
	{
		#if MOBILE_BUILD
		super('mobile/back');
		#else
		super('');
		#end

		positionOffset = mypositionOffset ?? new FlxPoint();

		justReleased.add(() ->
		{
			Global.playSoundEffect('blipSelect');
			Global.switchState(returnState);
		});
	}

	override function update(elapsed:Float)
	{
		desiredPosition.set(FlxG.width - this.width + 32 + (positionOffset.x ?? 0), FlxG.height - this.height + 32 + (positionOffset.y ?? 0));
		super.update(elapsed);
	}
}
