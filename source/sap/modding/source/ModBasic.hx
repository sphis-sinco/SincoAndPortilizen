package sap.modding.source;

class ModBasic extends FlxBasic
{
	/**
	 * This controls if the mod runs or not
	 */
	public var enabled:Bool = false;

	/**
	 * This tells if `create()` has been run
	 */
	public var has_run_create:Bool = false;

	/**
	 * New ModBasic.
	 * @param enabled Should the mod already be enabled
	 */
	override public function new(?enabled:Bool = false)
	{
		super();

		this.enabled = enabled;


                // ! Event signals ! \\
		FlxG.signals.focusGained.add(onFocusGained);
		FlxG.signals.focusLost.add(onFocusLost);

		FlxG.signals.gameResized.add(onGameResized);

		FlxG.signals.preStateCreate.add(onPreStateCreate);

		FlxG.signals.preUpdate.add(onPreUpdate);
		FlxG.signals.postUpdate.add(onPostUpdate);

		FlxG.signals.preStateSwitch.add(onStateSwitchStart);
		FlxG.signals.postStateSwitch.add(onStateSwitchComplete);
	}

	/**
	 * Initalization most likely to go here
	 */
	public function create():Void
	{
		has_run_create = true;
	}

	/**
	 * Run every frame
	 * @param elapsed elapsed
	 */
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	/**
	 * Toggles if the mod is enabled or not
	 * 
	 * If the mod hasn't run create then it is run
	 */
	public function toggleEnabled()
	{
		this.enabled = !this.enabled;

		if (!has_run_create)
			create();
	}

        // ! Event functions ! \\
        /**
	 * Event
	 */
	public function onFocusGained():Void;

	/**
	 * Event
	 */
	public function onFocusLost():Void;

	/**
	 * Event
	 */
	public function onGameResized(width:Int, height:Int):Void;

	/**
	 * Event
	 */
	public function onStateSwitchComplete():Void;

	/**
	 * Event
	 */
	public function onStateSwitchStart():Void;

}