package sap.utils;

class PausableState extends State
{
        public var paused:Bool = false;

	override public function new()
	{
		super();
	}

	override function create()
	{
		super.create();
	}

	override function update(elapsed:Float)
	{
                if (FlxG.keys.justReleased.ESCAPE)
                        togglePaused();

		super.update(elapsed);
	}

        public function togglePaused()
        {
                paused = !paused;
        }
}
