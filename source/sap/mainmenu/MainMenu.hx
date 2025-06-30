package sap.mainmenu;

import sap.changelog.ChangelogMenu;
import sap.credits.CreditsSubState;
import sap.settings.SettingsMenu;
import sap.title.TitleState;

class MainMenu extends State
{
	public static var sinco:MenuCharacter;
	public static var port:MenuCharacter;

	public static var gridbg:FlxSprite;
	public static var menuselectbox:FlxSprite;

	public static var menuboxtexts:FlxTypedGroup<FlxText>;
	public static var menutexts:Map<String, Array<String>> = [
		'menu' => ['play', 'credits', 'settings', 'changelog', 'leave'],
		'play' => ['new', 'continue', 'back']
	];

	public var menutextsSelection:String = 'menu';

	public static var public_menutextsSelection:String = 'menu';

	public static var menucharvis:Array<Bool> = null;

	public var CUR_SELECTION:Int = 0;

	public static var PUBLIC_CUR_SELECTION:Int = 0;

	public static var inSubstate:Bool = false;

	override public function new(select:String = 'menu'):Void
	{
		super();

		menutextsSelection = select;
	}

	override function create():Void
	{
		#if sys
		var menuArr:Array<String> = ['play', 'credits', 'settings', #if sys 'medals', #end 'changelog', 'leave'];
		if (ModFolderManager.MODS.length > 0)
			menuArr.insert(4, 'mods');
		menutexts.set('menu', menuArr);
		#end

		menucharvis ??= [false, true];

		gridbg = new FlxSprite();
		gridbg.loadGraphic(FileManager.getImageFile('mainmenu/MainMenuGrid'));
		Global.scaleSprite(gridbg, 0);
		gridbg.screenCenter();

		initChars();

		add(gridbg);
		add(sinco);
		add(port);

		menuselectbox = new FlxSprite();
		menuselectbox.makeGraphic(80, #if sys (ModFolderManager.MODS.length > 0) ? 104 : 80 #else 64 #end, FlxColor.BLACK);
		Global.scaleSprite(menuselectbox, 0);
		menuselectbox.screenCenter();
		add(menuselectbox);

		menuboxtexts = new FlxTypedGroup<FlxText>();
		set_menuboxtexts(menutextsSelection);
		add(menuboxtexts);

		cycle = public_cycle;

		sinco.animation.play((menucharvis[0]) ? 'visible' : 'blank');
		port.animation.play((menucharvis[1]) ? 'visible' : 'blank');

		gridBGAdapt();

		super.create();

		Global.changeDiscordRPCPresence('In the main menu', null);

		if (Global.previousState == 'ChangelogMenu')
			FlxG.camera.fade(FlxColor.BLACK, 1, true, () -> {});
	}

	public static var public_cycle:Int = 0;

	public var cycle:Int = 0;

	public static function gridBGAdapt():Void
	{
		if (port.animation.name == 'blank')
		{
			gridbg.x += 16 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER;
		}
		else
		{
			gridbg.x += -16 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER;
		}
	}

	override function update(elapsed:Float):Void
	{
		Global.playMenuMusic();

		cycle++;
		public_cycle = cycle;

		public_menutextsSelection = menutextsSelection;
		PUBLIC_CUR_SELECTION = CUR_SELECTION;

		if (cycle % 100 == 0)
		{
			cycle = 0;
			cycleUpdate();
		}

		for (text in menuboxtexts.members)
		{
			text.color = (CUR_SELECTION == text.ID) ? FlxColor.LIME : FlxColor.WHITE;
		}

		if (!inSubstate)
		{
			controls();
			CUR_SELECTION = PUBLIC_CUR_SELECTION;

			if (Global.keyJustReleased(ENTER))
			{
				selectionCheck();
			}
		}

		super.update(elapsed);
	}

	public static function controls():Void
	{
		if (Global.keyJustReleased(UP))
		{
			PUBLIC_CUR_SELECTION--;
			if (PUBLIC_CUR_SELECTION < 0)
			{
				trace('Prevent underflow');
				PUBLIC_CUR_SELECTION = 0;
			}
		}

		if (Global.keyJustReleased(DOWN))
		{
			PUBLIC_CUR_SELECTION++;
			if (PUBLIC_CUR_SELECTION > menuboxtexts.members.length - 1)
			{
				trace('Prevent overflow');
				PUBLIC_CUR_SELECTION = menuboxtexts.members.length - 1;
			}
		}
	}

	public static function set_menuboxtexts(mapstring:String):Void
	{
		TryCatch.tryCatch(() ->
		{
			for (text in menuboxtexts)
			{
				text.kill();
				menuboxtexts.remove(text);
			}
		});

		var i = 0;
		for (text in menutexts.get(mapstring))
		{
			var texty:Float = menuselectbox.y - menuselectbox.height + (i * 48);
			var newtext:FlxText = new FlxText(menuselectbox.x, texty, 0, Global.getLocalizedPhrase('$mapstring-$text', text), 32);
			newtext.screenCenter(X);

			newtext.alignment = CENTER;
			newtext.ID = i;

			menuboxtexts.add(newtext);
			i++;
		}
	}

	public static var CREDITS_SELECTION:Int = 1;
	public static var SETTINGS_SELECTION:Int = 2;
	public static var MEDALS_SELECTION:Int = 3;
	public static var MODS_SELECTION:Int = 4;

	public function selectionCheck():Void
	{
		if (public_menutextsSelection == 'menu')
		{
			if (PUBLIC_CUR_SELECTION == CREDITS_SELECTION)
			{
				inSubstate = true;
				openSubState(new CreditsSubState());
			}

			if (PUBLIC_CUR_SELECTION == SETTINGS_SELECTION)
			{
				inSubstate = true;
				openSubState(new SettingsMenu());
			}

			#if sys
			if (PUBLIC_CUR_SELECTION == MEDALS_SELECTION)
			{
				inSubstate = true;
				openSubState(new MedalsMenu());
			}
			if (PUBLIC_CUR_SELECTION == MODS_SELECTION)
			{
				if (ModFolderManager.MODS.length > 0)
				{
					inSubstate = true;
					openSubState(new sap.modding.menu.ModsMenu());
				}
				else
				{
					Global.switchState(new TitleState());
				}
			}
			#end

			menuSelection();
		}
	}

	public static function menuSelection():Void
	{
		switch (PUBLIC_CUR_SELECTION)
		{
			case 0:
				FlxG.switchState(PlayMenu.new);
			#if sys case 6: #else case 4: #end
				Global.switchState(new TitleState());
			#if sys case 5: #else case 3: #end
				FlxG.camera.fade(FlxColor.BLACK, 1, false, () ->
				{
					Global.switchState(new ChangelogMenu());
				});
		}
	}

	public static function cycleUpdate():Void
	{
		sinco.animation.play((sinco.animation.name == 'blank') ? 'visible' : 'blank');
		port.animation.play((port.animation.name == 'blank') ? 'visible' : 'blank');

		menucharvis[0] = sinco.animation.name == 'visible';
		menucharvis[1] = port.animation.name == 'visible';

		gridBGAdapt();
	}

	public static function initChars():Void
	{
		sinco = new MenuCharacter(0, 0, "Sinco");
		port = new MenuCharacter(0, 0, "Portilizen");

		sinco.screenCenter();
		port.screenCenter();

		sinco.x -= sinco.width * 2.5;
		port.x += port.width * 2.5;

		port.flipX = true;
		port.animation.play('visible');
	}
}
