package sap.utils;

class State extends FlxState
{
	override public function new():Void
	{
		SaveManager.save();

		// trace('Crashable state');

		super();

		ScriptManager.callScript('stateSwitched');
	}

	override function create():Void
	{
		super.create();

		ScriptManager.callScript('stateCreate');
		postCreate();
	}

	public function postCreate():Void
	{
		ScriptManager.callScript('statePostCreate');
	}

	override function update(elapsed:Float):Void
	{
		ScriptManager.callScript('stateUpdate', [elapsed]);
		super.update(elapsed);

		final controlPressed:Bool = Global.keyPressed(CONTROL);
		final altPressed:Bool = Global.keyPressed(ALT);
		final shiftPressed:Bool = Global.keyPressed(SHIFT);
		final lPressed:Bool = Global.keyPressed(L);
		final f5Pressed:Bool = Global.keyPressed(F5);

		if (controlPressed && altPressed && shiftPressed && lPressed)
		{
			ScriptManager.callScript('CASLCrash', [elapsed]);
			throw 'CASLCrash';
		}

		if (controlPressed && altPressed && shiftPressed && f5Pressed)
		{
			ScriptManager.callScript('GameRestart', [elapsed]);
                        FlxG.resetGame();
		}
	}
}
