package sap.credits;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import sap.mainmenu.MainMenu;

class CreditsSubState extends FlxSubState
{
        var overlay:BlankBG = new BlankBG();

        public static var creditsJSON:Array<CreditsEntry>;
        
        var creditsText:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

        override function create() {
                super.create();

                overlay.color = 0x000000;
                overlay.alpha = 0.5;
                add(overlay);

                add(creditsText);

                var cur_y:Float = 10;
                for (credit in creditsJSON)
                {
                        var text:FlxText = new FlxText(0, cur_y, 0, credit.text, Std.int(32 * credit.size));
                        text.screenCenter(X);
                        text.color = FlxColor.fromRGB(
                                credit.color[0],
                                credit.color[1],
                                credit.color[2], 
                                (credit.color[3] != null) ? credit.color[3] : 255
                                );

                        creditsText.add(text);

                        cur_y += credit.spacing;
                }
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