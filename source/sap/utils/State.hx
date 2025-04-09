package sap.utils;

import sap.modding.source.ModListManager;

class State extends FlxState
{
	override public function new():Void
	{
                // trace('Crashable state');

		super();
	}

	override function create():Void
	{
		super.create();

		postCreate();
	}

	public function postCreate():Void {}

	override function update(elapsed:Float):Void
	{
		ModListManager.update(elapsed);
		super.update(elapsed);

                if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.ALT && FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.L)
                {
                        throw 'Ctrl+Alt+Shift+L';
                }
	}
}
