package sap.utils;

import funkin.ui.transition.StickerSubState;


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

                if (StickerSubState.grpStickers != null)
                {
                        trace('Degen stickers');
                        Global.switchState(this, true);
                }
        }

	override function update(elapsed:Float):Void
	{
                ScriptManager.callScript('stateUpdate', [elapsed]);
		super.update(elapsed);

                if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.ALT && FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.L)
                {
                        ScriptManager.callScript('CASLCrash', [elapsed]);
                        throw 'CASLCrash';
                }
	}
}
