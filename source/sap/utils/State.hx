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

	public function postCreate():Void {
                ScriptManager.callScript('statePostCreate');
        }

	override function update(elapsed:Float):Void
	{
		ModListManager.update(elapsed);
                ScriptManager.callScript('stateUpdate', [elapsed]);
		super.update(elapsed);

                if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.ALT && FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.L)
                {
                        ScriptManager.callScript('CASLCrash', [elapsed]);
                        throw 'CASLCrash';
                }
	}
}
