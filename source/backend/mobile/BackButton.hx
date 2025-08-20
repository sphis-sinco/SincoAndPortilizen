package backend.mobile;

class BackButton extends Spr
{
	public var returnState:FlxState;

	override public function new(myreturnstate:FlxState)
	{
		super();
		loadGraphic(Assets.getImagePath('mobile/back'));

		returnState = myreturnstate;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		scaleSpr();
		setPosition(FlxG.width - this.width + 32, FlxG.height - this.height + 32);
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
