package levels;

import flixel.group.FlxGroup.FlxTypedGroup;

class StringQuest extends PausableState
{
	public var levelLength:Int = 10;
	public var levelBlocks:FlxTypedGroup<Spr>;

	override public function new()
	{
		super();

		FlxG.sound.music.stop();
	}

	override function create()
	{
		super.create();

		levelBlocks = new FlxTypedGroup<Spr>();
		add(levelBlocks);

		for (i in 0...levelLength) {
			var spr:Spr = new Spr();
			spr.loadGraphic(Assets.getImagePath('string-quest/block'));
			
			spr.y = FlxG.height - spr.height;
			spr.x = spr.width * i;
			
			levelBlocks.add(spr);
		}
	}
}
