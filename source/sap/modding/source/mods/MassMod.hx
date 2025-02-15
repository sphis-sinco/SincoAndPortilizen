package sap.modding.source.mods;

import flixel.util.FlxColor;
import sap.credits.CreditsEntry;
import sap.credits.CreditsSubState;
import sap.mainmenu.MainMenu;
import sap.title.TitleState;

class MassMod extends ModBasic
{
	public static var instance:ModBasic;
	var canModCredits:Bool = false;

	override public function new()
	{
		super(false);

		instance = this;
	}

	override function create()
	{
		trace('Mass mod');

		TitleState.get_versiontext = function():String
		{
			return 'v6969';
		}

		super.create();
	}

	override function onStateSwitchComplete()
	{
		super.onStateSwitchComplete();

		if (Global.getCurrentState() == "TitleState")
		{
			trace('Title!');
		}

		if (Global.getCurrentState() == "MainMenu" || Global.getCurrentState() == "PlayMenu")
		{
			trace('Menu!');
			MainMenu.sinco.visible = false;
			MainMenu.port.visible = false;
		}
	}

	override function onPostUpdate()
	{
		super.onPostUpdate();
                canModCredits = (CreditsSubState != null);

		TryCatch.tryCatch(() ->
		{
			if (canModCredits)
			{
				CreditsSubState.overlay.color = FlxColor.WHITE;
			}
		});
	}

	override function onPreStateCreate(state:FlxState)
	{
		super.onPreStateCreate(state);

		if (canModCredits)
                {
                        trace('Credits Menu!');

                        if (!CreditsSubState.creditsJSON.contains(coolCredits[0]))
                        {
                                CreditsSubState.creditsJSON.push(coolCredits[0]);
                                CreditsSubState.creditsJSON.push(coolCredits[1]);
                        }
                }
	}

        var coolCredits:Array<CreditsEntry> = [
                { text: "COOLIO MODDING", size: 2, color: [0,0,0], spacing: 100 },
                { text: "SINCO", size: 1, color: [0,0,0], spacing: 50 }
        ];

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
