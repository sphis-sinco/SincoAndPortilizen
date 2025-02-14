package sap.credits;

import sap.mainmenu.MainMenu;

class CreditsSubState extends FlxSubState
{
        override public function new() {
                super();
        }

        override function create() {
                super.create();
        }

        override function update(elapsed:Float) {
                super.update(elapsed);

                if (FlxG.keys.justReleased.ESCAPE)
                {
                        MainMenu.inCredits = false;
                        close();
                }
        }
        
}