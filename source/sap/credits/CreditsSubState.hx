package sap.credits;

import sap.mainmenu.MainMenu;

class CreditsSubState extends FlxSubState
{
        var overlay:BlankBG = new BlankBG();
        
        override public function new() {
                super();
        }

        override function create() {
                super.create();

                overlay.color = 0x000000;
                overlay.alpha = 0.5;
                add(overlay);
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