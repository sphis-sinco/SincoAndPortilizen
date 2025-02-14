package sap.credits;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import sap.mainmenu.MainMenu;

class CreditsSubState extends FlxSubState
{
        var overlay:BlankBG = new BlankBG();

        public static var creditsJSON:Array<CreditsEntry>;
        
        var creditsText:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

        override public function new() {
                super();
        }

        override function create() {
                super.create();

                overlay.color = 0x000000;
                overlay.alpha = 0.5;
                add(overlay);

                add(creditsText);
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