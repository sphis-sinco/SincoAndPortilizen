package sap.stages;

import sap.worldmap.Worldmap;

class Continue extends State
{
	override function create()
	{
		super.create();

		FlxG.switchState(() -> new Worldmap());
	}
}
