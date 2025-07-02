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

	public function postCreate():Void
	{
		ScriptManager.callScript('statePostCreate');
		stickerTransitionClear();
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
		final f1Pressed:Bool = Global.keyPressed(F1);

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

	public function stickerTransitionClear()
	{
		if (StickerSubState.grpStickers.length > 0)
		{
			switchState(this, true);
			ScriptManager.callScript('stickerTransitionClear');
		}
	}

	public function switchState(new_state:FlxState, ?oldStickers:Bool = false, ?stickerSet:String = 'R', ?stickerPack:String = 'R')
	{
		var ss = stickerSet;
		var sr = stickerPack;

		if (ss == 'R')
		{
			ss = Global.randomStickerFolder();
		}
		if (sr == 'R')
		{
			sr = Global.randomStickerPack(ss);
		}

		Global.switchState(new_state, oldStickers, ss, sr);
	}
}
