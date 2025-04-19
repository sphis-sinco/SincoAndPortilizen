package sap.stages.stage5;

typedef Stage5DifficultyJson = {
        var opponent_charge_tick_goal:Int;
        var opponent_charge_random_tick_pause_min:Int;
        var opponent_charge_random_tick_pause_max:Int;
        var opponent_pause_tick_start_value:Int;
        var opponent_pause_change:Int;
        var opponent_lockin_offset:Float;
        var opponent_pause_tick_goal:Int;

        var timer:Int;
}