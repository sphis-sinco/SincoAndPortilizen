package backend;

class Spr extends FlxSprite
{
	override public function new(init:Void->Void, scaleOffset:Int = 0)
	{
		super(0,0);

		init();

                Global.scaleSprite(this, scaleOffset);
	}
}
