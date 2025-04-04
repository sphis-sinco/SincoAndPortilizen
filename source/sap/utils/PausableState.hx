package sap.utils;

class PausableState extends State
{
        public var paused:Bool = false;

	override public function new():Void
	{
		super();
	}

	override function create():Void
	{
		super.create();
	}

	override function update(elapsed:Float):Void
	{
                if (FlxG.keys.justReleased.ESCAPE)
                {
                        togglePaused();
                }

		super.update(elapsed);
	}

        public function togglePaused():Void
        {
                paused = !paused;
        }
}
