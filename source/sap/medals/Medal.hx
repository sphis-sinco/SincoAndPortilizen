package sap.medals;

class Medal extends FlxTypedGroup<FlxObject>
{
	var medalBox:MedalBox;

	var medalIcon:FlxSprite;

	public var waitTime:Float = 2;
	public var fadeWaitTime:Float = 1;

	override public function new(medal:String = 'award', earnedAlready:Bool = false):Void
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

		trace(path);

		medalIcon = new FlxSprite().loadGraphic(path);
		add(medalIcon);
		Global.scaleSprite(medalIcon, -2);

		final offset:Float = 2 * 4;
		medalIcon.setPosition(medalBox.HORIZONTAL_POSITION + offset, medalBox.VERTICAL_POSITION + offset);

		if (earnedAlready)
		{
			medalBox.destroy();
			medalIcon.destroy();
			this.destroy();
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
			});
		});
	}
}
