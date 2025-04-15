package sap.outdated;

class OutdatedMenu extends State
{
	public static var OUTDATED_TEXT:String = '// ! You are running an outdated version ([VERSION]) ! \\'
		+ '\n\nIt is recommended to update to the latest version'
                + '\nespecally if you are working on a mod with script files';

        public static var BEGONE:Bool = false;

	override function create()
	{
		super.create();

                BEGONE = true;
                var text:FlxText = new FlxText(0,0,0,OUTDATED_TEXT.replace('[VERSION]', '${Global.VERSION}'),16);
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
