package sap.utils;

import sap.modding.source.ModListManager;

class State extends FlxState
{
	override public function new()
	{
		super();
	}

	override function create()
	{
		super.create();

		postCreate();
	}

	public function postCreate():Void {}

	override function update(elapsed:Float)
	{
		ModListManager.update(elapsed);
		super.update(elapsed);
	}
}
