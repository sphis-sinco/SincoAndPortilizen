package sap.sidebitmenu;

class SidebitSelect extends State
{
	override function create()
	{
		var bg:FlxSprite = new FlxSprite();
		bg.loadGraphic(FileManager.getImageFile('sidebitmenu/background'));
		add(bg);
		bg.screenCenter();

		var tv:FlxAnimate = new FlxAnimate(0, 0, 'assets/images/sidebitmenu/tv');
		tv.anim.addBySymbol('animation', 'static tv', 24, true);
		tv.anim.play('animation');
		add(tv);
		tv.screenCenter();
		tv.y += tv.height;

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
