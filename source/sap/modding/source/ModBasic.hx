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
	override public function new(?enabled:Bool = false):Void
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
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	/**
	 * Toggles if the mod is enabled or not
	 * 
	 * If the mod hasn't run create then it is run
	 */
	public function toggleEnabled():Void
	{
		this.enabled = !this.enabled;

		if (!has_run_create)
		{
			create();
		}
	}

	// ! Event functions ! \\

	/**
	 * Event
	 */
	public function onFocusGained():Void
	{
		return;
	}

	/**
	 * Event
	 */
	public function onFocusLost():Void
	{
		return;
	}

	/**
	 * Event
	 */
	public function onGameResized(width:Int, height:Int):Void
	{
		return;
	}

	/**
	 * Event
	 */
	public function onPreStateCreate(state:FlxState):Void
	{
		return;
	}

	/**
	 * Event
	 */
	public function onPreUpdate():Void
	{
		return;
	}

	/**
	 * Event
	 */
	public function onPostUpdate():Void
	{
		return;
	}

	/**
	 * Event
	 */
	public function onStateSwitchComplete():Void
	{
		return;
	}

	/**
	 * Event
	 */
	public function onStateSwitchStart():Void
	{
		return;
	}
}
