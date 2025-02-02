package stages;

import stages.stage1.Stage1;

class Continue extends FlxState
{

    override function create() {
        super.create();

        FlxG.save.data.gameplaystatus ??= GameplayStatus.returnDefaultGameplayStatus();

        switch (FlxG.save.data.gameplaystatus.level)
        {
            case 1:
                FlxG.switchState(Stage1.new);
        }

    }
    
}