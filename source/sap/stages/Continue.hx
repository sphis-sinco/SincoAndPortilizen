package stages;

import stages.stage1.Stage1;
import worldmap.Worldmap;

class Continue extends FlxState
{

    override function create() {
        super.create();

        FlxG.save.data.gameplaystatus ??= GameplayStatus.returnDefaultGameplayStatus();
        
        FlxG.switchState(() -> new Worldmap());
    }
    
}