package levels;

import flixel.group.FlxGroup.FlxTypedGroup;

class StringQuest extends PausableState
{
	public var levelLength:Int = 20;
	public var levelBlocks:FlxTypedGroup<Spr>;

	override public function new()
		super();

	override function create()
	{
		super.create();

		levelBlocks = new FlxTypedGroup<Spr>();
		add(levelBlocks);

		for (i in 0...levelLength)
		{
			var spr:Spr = new Spr();
			spr.loadGraphic(Assets.getImagePath('string-quest/block'));

			spr.y = FlxG.height - spr.height;
			if (i > 9)
				spr.y -= spr.height;
			spr.x = spr.width * (i - ((i > 9) ? 10 : 0));

			levelBlocks.add(spr);
		}

		FlxG.sound.music.stop();
	}
}
