package sap.cutscenes;

typedef CutsceneJson =
{
	var type:String;
	var assetPath:String;

        // Sparrow
	var ?parts:Int;
	var ?symbol_names:Array<String>;
	var ?offsets:Array<Array<Float>>;
}
