package sap.credits;

import sap.mainmenu.MainMenu;

class CreditsSubState extends FlxSubState
{
        override public function new() {
                super();

                trace('Inside the CSS');
        }

        override function create() {
                super.create();
        }

        override function update(elapsed:Float) {
                super.update(elapsed);

                if (FlxG.keys.justReleased.ESCAPE)
                {
                        trace('Outside the CSS');
                        MainMenu.inCredits = false;
                        closeSubState();
                }
        }
        
}