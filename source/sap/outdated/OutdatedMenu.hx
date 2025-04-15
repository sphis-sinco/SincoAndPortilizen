package sap.outdated;

class OutdatedMenu extends State
{
        // heh
	public static var OUTDATED_TEXT:String = '// ! You are running an outdated version (${Global.VERSION}) ! \\'
		+ '\n\nIt is recommended to update to the latest version'
                + '\nespecally if you are working on a mod with script files';

	override function create()
	{
		super.create();

                var text:FlxText = new FlxText(0,0,0,OUTDATED_TEXT,16);
                text.alignment = CENTER;
                text.screenCenter();
                add(text);
	}

        override function update(elapsed:Float) {
                super.update(elapsed);

                if (FlxG.keys.justReleased.ENTER)
                {
                        InitState.proceed();
                }
        }
}
