package sap.medals;

class Medal extends FlxTypedGroup<FlxObject>
{
	var medalBox:MedalBox;

	var medalIcon:FlxSprite;

	public var waitTime:Float = 2;
	public var fadeWaitTime:Float = 1;

	override public function new(medal:String = 'award', earnedAlready:Bool = false, y_offset:Float):Void
	{
		super();

		medalBox = new MedalBox();
		add(medalBox);
		final medalboxmid:FlxPoint = medalBox.getMidpoint();

		var path:String = FileManager.getImageFile('${medalBox.assetFolder}/awards/${medal}');

		if (!FileManager.exists(path))
		{
			trace('${medal} does not have an icon');
                        path = FileManager.getImageFile('${medalBox.assetFolder}/awards/award');
		}
		// trace(path);

		medalIcon = new FlxSprite().loadGraphic(path);
		add(medalIcon);
		Global.scaleSprite(medalIcon, -2);

		final offset:Float = 2 * 4;
		medalIcon.setPosition(medalBox.HORIZONTAL_POSITION + offset, medalBox.VERTICAL_POSITION + offset);

                medalBox.y += y_offset;
                medalIcon.y += y_offset;

		if (earnedAlready)
		{
			medalBox.destroy();
			medalIcon.destroy();
			this.destroy();
                        MedalData.cur_y_offset -= 16 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER;
		}

		FlxTimer.wait(waitTime, () ->
		{
			FlxTween.tween(medalBox, {alpha: 0}, fadeWaitTime, {onComplete: tween ->
			{
				medalBox.destroy();
			}});
			FlxTween.tween(medalIcon, {alpha: 0}, fadeWaitTime, {onComplete: tween ->
			{
				medalIcon.destroy();
			}});
			FlxTimer.wait(fadeWaitTime, () ->
			{
				this.destroy();
                                MedalData.cur_y_offset -= 16 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER;
			});
		});
	}
}
