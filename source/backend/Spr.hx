package backend;

class Spr extends FlxSprite
{
	override public function new(init:Spr->Void, scaleOffset:Int = 0)
	{
		super(0,0);

		init(this);

                Global.scaleSprite(this, scaleOffset);
	}
}
