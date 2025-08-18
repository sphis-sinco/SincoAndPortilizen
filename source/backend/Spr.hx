package backend;

class Spr extends FlxSprite
{
	public var scaleOffset:Float = 0;

	public function scaleSpr()
		Global.scaleSprite(this, scaleOffset);

	override public function new(scaleOffset:Float = 0)
	{
		super(0,0);
		this.scaleOffset = scaleOffset;
	}
}
