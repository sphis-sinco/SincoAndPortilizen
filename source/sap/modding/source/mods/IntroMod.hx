package sap.modding.source.mods;

import sap.title.TitleState;

class IntroMod extends ModBasic
{
	public static var instance:ModBasic;

	override public function new()
	{
		super(false);

		instance = this;
	}

	override function create()
	{
		trace('Intro mod');

		TitleState.get_versiontext = function():String
		{
			return 'v6969';
		}

		super.create();
	}

        override function onStateSwitchComplete() {
                super.onStateSwitchComplete();

                if (Global.getCurrentState() == "TitleState")
                {
                        trace('Title!');
                }
        }

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
