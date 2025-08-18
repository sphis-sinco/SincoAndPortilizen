package backend;

import menus.LevelSelect;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;

class PausableState extends State
{
	public var paused:Bool = false;

	var builtInPausing:Bool = false;

	override public function new(builtInPausing:Bool = true):Void
	{
		this.builtInPausing = builtInPausing;

		super();
	}

	public var overlay:Spr;
	public var pauseText:FlxText;

	override function create():Void
		super.create();

	override function update(elapsed:Float):Void
	{
		if (Global.keyJustReleased(ESCAPE) && builtInPausing)
			togglePaused();

		if (Global.keyJustReleased(SPACE) && paused)
			Global.switchState(new LevelSelect());

		FlxTween.globalManager.active = !paused;
		FlxTimer.globalManager.active = !paused;

		super.update(elapsed);
	}

	public function togglePaused():Void
	{
		paused = !paused;

		if (!paused)
		{
			overlay.destroy();
			pauseText.destroy();
		}
		else
		{
			overlay = Global.dummyBG([12, 12, 12]);
			overlay.alpha = 0.5;
			add(overlay);

			pauseText = new FlxText(0, 0, 0, 'PAUSED\n\n[SPACE] to go to the Level Select', 64);
			pauseText.alignment = 'center';
			pauseText.screenCenter(XY);
			add(pauseText);
		}
	}
}
