package sap.utils;

class PausableState extends State
{
	public var paused:Bool = false;

	var builtin:Bool = false;

	override public function new(builtin:Bool = true):Void
	{
		this.builtin = builtin;

		super();
	}

	public static var overlay:BlankBG;
	public static var pauseText:FlxText;

	override function create():Void
	{
		super.create();
	}

	override function postCreate()
	{
		super.postCreate();
	}

	override function update(elapsed:Float):Void
	{
		if (Global.keyJustReleased(ESCAPE) && builtin)
		{
			togglePaused();
		}

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
			overlay = new BlankBG();
			overlay.color = 0x000000;
			overlay.alpha = 0.5;
			add(overlay);

			pauseText = new FlxText(0, 0, 0, Global.getLocalizedPhrase('pauseable-pause'), 64);
			pauseText.screenCenter(XY);
			// pauseText.y = pauseText.size * 2;
			add(pauseText);
		}
	}
}
