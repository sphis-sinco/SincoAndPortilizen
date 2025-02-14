package sap.adv.spr;

typedef AdvancedSpriteParams =
{
	public var X:Null<Float>;
	public var Y:Null<Float>;
	public var asset_path:String;
	public var ?px_animated:Bool;
	public var ?px_width:Int;
	public var ?px_height:Int;
	public var ?px_animations:Array<PX_Animations>;
}

typedef PX_Animations = {
        public var name:String;
        public var frames:Array<Int>;
        public var ?fps:Float;
        public var ?loop:Bool;
}
