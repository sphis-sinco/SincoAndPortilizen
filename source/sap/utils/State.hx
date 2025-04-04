package sap.utils;

import sap.modding.source.ModListManager;

class State extends FlxState
{
	override public function new():Void
	{
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
	}
}
