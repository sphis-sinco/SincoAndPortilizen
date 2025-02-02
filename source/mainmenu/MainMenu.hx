package mainmenu;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import title.TitleState;

class MainMenu extends FlxState
{
	var sinco:MenuCharacter = new MenuCharacter(0, 0, "Sinco");
	var port:MenuCharacter = new MenuCharacter(0, 0, "Portilizen");

	var gridbg:FlxSprite = new FlxSprite();
	var menuselectbox:FlxSprite = new FlxSprite();

	var menuboxtexts:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();
	var menutexts:Map<String, Array<String>> = ['menu' => ['play', 'leave'], 'play' => ['new', 'continue', 'back']];

	public var menutextsSelection:String = 'menu';

	public static var menucharvis:Array<Bool> = null;
	
	var CUR_SELECTION:Int = 0;

	override public function new(select:String = 'menu') {
		super();

		menutextsSelection = select;
	}

	override function create()
	{
		menucharvis ??= [false, true];
		
		gridbg.loadGraphic(FileManager.getImageFile('mainmenu/MainMenuGrid'));
		Global.scaleSprite(gridbg, 0);
		gridbg.screenCenter();
		gridbg.x += ((port.animation.name == 'blank') ? 16 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER : -16 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER);
		add(gridbg);

		sinco.screenCenter();
		port.screenCenter();

		sinco.x -= sinco.width * 2;
		port.x += port.width * 2;

		add(sinco);

		port.flipX = true;
		add(port);
		port.animation.play('visible');

		menuselectbox.makeGraphic(64, 64, FlxColor.BLACK);
		Global.scaleSprite(menuselectbox, 0);
		menuselectbox.screenCenter();
		add(menuselectbox);

		set_menuboxtexts(menutextsSelection);

		add(menuboxtexts);		

        this.cycle = public_cycle;

        this.sinco.animation.play((menucharvis[0]) ? 'visible' : 'blank');
        this.port.animation.play((menucharvis[1]) ? 'visible' : 'blank');

		super.create();
	}

	public static var public_cycle:Int = 0;
	public var cycle:Int = 0;

	override function update(elapsed:Float)
	{
		cycle++;
		public_cycle = cycle;

		if (cycle % 100 == 0)
		{
			cycleUpdate();
		}

		for (text in menuboxtexts.members)
		{
			text.color = (CUR_SELECTION == text.ID) ? FlxColor.LIME : FlxColor.WHITE;
		}

		if (FlxG.keys.justReleased.UP)
		{
			CUR_SELECTION--;
			if (CUR_SELECTION < 0)
				CUR_SELECTION = 0;
		}

		if (FlxG.keys.justReleased.DOWN)
		{
			CUR_SELECTION++;
			if (CUR_SELECTION > menuboxtexts.members.length - 1)
				CUR_SELECTION = menuboxtexts.members.length - 1;
		}

		if (FlxG.keys.justReleased.ENTER)
		{
			selectionCheck();
		}

		super.update(elapsed);
	}

	public function set_menuboxtexts(mapstring:String)
	{
		if (menuboxtexts.members.length > 0)
		{
			for (text in menuboxtexts)
			{
				text.destroy();
				menuboxtexts.remove(text);
			}
		}


		var i = 0;
		for (text in menutexts.get(mapstring))
		{
			var newtext:FlxText = new FlxText(menuselectbox.x, menuselectbox.y - menuselectbox.height + (i * 48), 0, text, 32);
			newtext.screenCenter(X);

			newtext.alignment = CENTER;
			newtext.ID = i;

			menuboxtexts.add(newtext);
			i++;
		}
	}

	public function selectionCheck()
	{
		switch (CUR_SELECTION)
			{
				case 0:
					FlxG.switchState(PlayMenu.new);
				case 1:
					FlxG.switchState(TitleState.new);
			}
	}

	public function cycleUpdate() {
		if (cycle % 100 == 0) cycle = 0;

		sinco.animation.play((sinco.animation.name == 'blank') ? 'visible' : 'blank');
		port.animation.play((port.animation.name == 'blank') ? 'visible' : 'blank');

		menucharvis[0] = sinco.animation.name == 'visible';
		menucharvis[1] = port.animation.name == 'visible';

		gridbg.x += ((port.animation.name == 'blank') ? 16 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER : -16 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER);
	}
}
