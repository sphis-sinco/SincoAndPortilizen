package sap.sidebitmenu;

class SidebitSelect extends State
{
	override function create()
	{
                Global.playMusic('Lado', 1.0, true);

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

                var side1:FlxSprite = new FlxSprite();
                side1.loadGraphic(FileManager.getImageFile('sidebitmenu/stage_side'));
                side1.screenCenter();
                side1.x += (side1.width / 1.2);
                side1.y += 35;
                add(side1);

                var side2:FlxSprite = new FlxSprite();
                side2.loadGraphic(FileManager.getImageFile('sidebitmenu/stage_side'));
                side2.flipX = true;
                side2.screenCenter();
                side2.x -= (side2.width / 1.2);
                side2.y = side1.y;
                add(side2);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
