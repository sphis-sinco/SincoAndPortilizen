package backend.mobile;

import flixel.math.FlxPoint;

class BackButton extends Spr
{
	public var returnState:FlxState;

        public var positionOffset:FlxPoint;

	override public function new(myreturnstate:FlxState, mypositionOffset:FlxPoint = null)
	{
		super();
		loadGraphic(Assets.getImagePath('mobile/back'));

		returnState = myreturnstate;
                positionOffset = mypositionOffset ?? new FlxPoint();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		scaleSpr();
		setPosition(FlxG.width - this.width + 32 + (positionOffset.x ?? 0), FlxG.height - this.height + 32 + (positionOffset.y ?? 0));
		if (FlxG.mouse.overlaps(this))
			scale.set(scale.x - .1, scale.y - .1)
		else
			scaleSpr();

		if (FlxG.mouse.justReleased && FlxG.mouse.overlaps(this))
		{
			Global.playSoundEffect('blipSelect');
			Global.switchState(returnState);
		}
	}
}
