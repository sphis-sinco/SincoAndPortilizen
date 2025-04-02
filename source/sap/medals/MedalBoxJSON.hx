package sap.medals;

typedef MedalBoxJSON = {
	var animation_order:Array<String>;
	var animation_data:Array<AnimData>;
}

typedef AnimData = {
	var Name:String;
	var Asset:String;
	var ?FPS:Float;
	var Animated:Bool;
	var ?Animation_Frames:Int;
}