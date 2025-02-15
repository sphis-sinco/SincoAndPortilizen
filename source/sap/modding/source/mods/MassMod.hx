package sap.modding.source.mods;

import sap.mainmenu.MainMenu;
import sap.title.TitleState;

class MassMod extends ModBasic
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

                if (Global.getCurrentState() == "MainMenu")
                {
                        trace('Menu!');
                        MainMenu.sinco.visible = false;
                        MainMenu.port.visible = false;
                }
        }

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
