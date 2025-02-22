package sap.stages;

import sap.worldmap.Worldmap;

class Continue extends State
{
	override function create()
	{
		super.create();

		FlxG.save.data.gameplaystatus ??= GameplayStatus.returnDefaultGameplayStatus();

		FlxG.switchState(() -> new Worldmap());
	}
}
