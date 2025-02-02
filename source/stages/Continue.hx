package stages;

import stages.stage1.Stage1;

class Continue extends FlxState
{

    override function create() {
        super.create();

        if (FlxG.save.data.gameplaystatus == null)
        {
            FlxG.save.data.gameplaystatus = {
                level: 1
            };
        }

        switch (FlxG.save.data.gameplaystatus.level)
        {
            case 1:
                FlxG.switchState(Stage1.new);
        }

    }
    
}