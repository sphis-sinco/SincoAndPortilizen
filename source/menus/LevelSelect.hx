package menus;

class LevelSelect extends FlxState
{
	override function create()
	{
                var background:Spr = new Spr(spr -> {
                        spr.makeGraphic(Std.int(640 / 4), Std.int(608 / 4), 0xe2e2e2);
                });
                add(background);

		super.create();
	}
}
