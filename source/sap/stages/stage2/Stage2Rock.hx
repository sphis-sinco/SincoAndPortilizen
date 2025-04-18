package sap.stages.stage2;

class Stage2Rock extends FlxSprite
{
	public var playedBlowUp:Bool = false;

	override public function new():Void
	{
		super();

		loadGraphic(FileManager.getImageFile('gameplay/sinco stages/Stage2Rocks'), true, 32, 32);

		var framesArray:Array<Int> = [];
		var i:Int = 0;
		while (i < animation.numFrames)
		{
			framesArray.push(i);

			i++;
		}

		FlxG.watch.addQuick('Rock frames array', framesArray);

		animation.frameIndex = FlxG.random.int(0, framesArray[framesArray.length - 1]);

		Global.scaleSprite(this);
	}

	public function blowUpSFX():Void
	{
		if (playedBlowUp)
			return;

		Global.playSoundEffect('gameplay/blow-up');
		playedBlowUp = true;
	}
}
