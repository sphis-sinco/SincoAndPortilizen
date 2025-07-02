package sap.utils;

class PausableState extends State
{
	public var paused:Bool = false;

	public var leftArt:FlxSprite;
	public var centerArt:FlxSprite;
	public var rightArt:FlxSprite;

	public var artEnabled:Array<Bool> = [false, false, false];
	public var artStrings:Array<String> = ['', '', ''];

	var builtin:Bool = false;

	override public function new(builtin:Bool = true):Void
	{
		this.builtin = builtin;

		artInit = function(index:Int)
		{
			var art = new FlxSprite().loadGraphic(FileManager.getImageFile('pausemenu/${artStrings[0]}'));
			art.y = FlxG.height - art.height / 1.5;

			art.x = art.width * 1.2;
			if (index == 1)
				art.screenCenter(X);
			if (index == 2)
				art.x = FlxG.width - art.width * 1.2;
			return art;
		}

		paoStuff = function(art:FlxSprite, index:Int, suffix:String = '')
		{
			var pos = [art.getPosition().x, art.getPosition().y];

			var paoPath = 'assets/images/pausemenu/${artStrings[index]}${suffix}.pao';

			// PAO
			// Pause Art Offset
			if (FileManager.exists(paoPath))
			{
				var paoFile = FileManager.readFile(paoPath).split('\n');
				pos[0] += Std.parseFloat(paoFile[0]);
				pos[1] += Std.parseFloat(paoFile[1]);
			}

			return pos;
		}

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

		if (Global.keyJustReleased(SPACE) && paused)
		{
			switch (Global.getCurrentState())
			{
				default:
					Global.switchState(new Worldmap());
				case 'Stage4', 'Stage5':
					Global.switchState(new Worldmap('port'));
			}
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

			if (leftArt != null)
				leftArt.destroy();
			if (centerArt != null)
				centerArt.destroy();
			if (rightArt != null)
				rightArt.destroy();
		}
		else
		{
			overlay = new BlankBG();
			overlay.color = 0x000000;
			overlay.alpha = 0.5;
			add(overlay);

			pauseText = new FlxText(0, 0, 0, Global.getLocalizedPhrase('pauseable-pause'), 64);
			pauseText.screenCenter(XY);
			pauseText.y = pauseText.size * 2;
			add(pauseText);

			if (artEnabled[0])
			{
				leftArt = artInit(0);
				add(leftArt);

				leftArt.x = paoStuff(leftArt, 0, '-left')[0];
				leftArt.y = paoStuff(leftArt, 0, '-left')[1];
			}

			if (artEnabled[1])
			{
				centerArt = artInit(1);
				add(centerArt);

				centerArt.x = paoStuff(centerArt, 2, '-center')[0];
				centerArt.y = paoStuff(centerArt, 2, '-center')[1];
			}

			if (artEnabled[2])
			{
				rightArt = artInit(2);
				add(rightArt);

				rightArt.x = paoStuff(rightArt, 2, '-right')[0];
				rightArt.y = paoStuff(rightArt, 2, '-right')[1];
			}
		}
	}

	var artInit:Dynamic;

	var paoStuff:Dynamic;
}
