package sap.mainmenu;

class MenuCharacter extends AdvancedSprite
{
	override public function new(?X:Float = 0, ?Y:Float = 0, CHARSUFFIX:String = 'Sinco')
	{
		super({
			X: X,
			Y: Y,
                        asset_path: null
		});
		loadGraphic(FileManager.getImageFile('mainmenu/MainMenu$CHARSUFFIX'), true, 80, 96);
		animation.add('visible', [0]);
		animation.add('blank', [1]);
		animation.play('blank');
		Global.scaleSprite(this, 0);
	}
}
