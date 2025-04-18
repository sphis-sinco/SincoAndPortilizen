package sap.cutscenes;

typedef CutsceneJson =
{
	var type:String;

	// Comic
	var ?max_panels:Null<Int>;

	var ?panel_folder:String;
	var ?panel_prefix:String;

	var ?rpc_details:String;
	var ?rpc_state:Null<String>;

	// Sparrow and Atlas
	var ?assetPath:String;
	var ?parts:Int;
	var ?symbol_names:Array<String>;

	// Sparrow only
	var ?offsets:Array<Array<Float>>;
}
