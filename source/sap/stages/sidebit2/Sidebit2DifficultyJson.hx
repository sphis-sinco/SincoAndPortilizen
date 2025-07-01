package sap.stages.sidebit2;

typedef Sidebit2DifficultyJson =
{
	var player_max_health:Int;
	var player_can_do_things_tick:Int;

	var opponent_max_health:Int;

	var op_attack_chance:Float;
	var op_atk_tick:Int;
	var op_atk_tick_random_min:Int;
	var op_atk_tick_random_max:Int;
	
	var op_def_chance:Float;
	var op_def_chance_didnt_hit:Float;
	var op_def_chance_did_hit:Float;
}