package mainmenu;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class MainMenu extends FlxState
{
	var sinco:MenuCharacter = new MenuCharacter(0, 0, "Sinco");
	var port:MenuCharacter = new MenuCharacter(0, 0, "Portilizen");

	var gridbg:FlxSprite = new FlxSprite();
	var menuselectbox:FlxSprite = new FlxSprite();

	var menuboxtexts:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();
	var menutexts:Map<String, Array<String>> = ['menu' => ['play', 'exit'], 'play' => ['new', 'continue', 'back']];
	
	var CUR_SELECTION:Int = 0;

	override function create()
	{
		gridbg.loadGraphic(FileManager.getImageFile('mainmenu/MainMenuGrid'));
		add(gridbg);
		gridbg.scale.set(Global.DEFAULT_IMAGE_SCALE_MULTIPLIER, Global.DEFAULT_IMAGE_SCALE_MULTIPLIER);
		gridbg.screenCenter();

		sinco.screenCenter();
		port.screenCenter();

		sinco.x -= sinco.width * 2;
		port.x += port.width * 2;

		add(sinco);

		port.flipX = true;
		add(port);
		port.animation.play('visible');

		menuselectbox.makeGraphic(64, 64, FlxColor.BLACK);
		menuselectbox.scale.set(Global.DEFAULT_IMAGE_SCALE_MULTIPLIER, Global.DEFAULT_IMAGE_SCALE_MULTIPLIER);
		menuselectbox.screenCenter();
		add(menuselectbox);

		set_menuboxtexts('menu');

		add(menuboxtexts);

		super.create();
	}

	var cycle:Int = 0;

	override function update(elapsed:Float)
	{
		cycle++;

		if (cycle % 100 == 0)
		{
			cycle = 0;
			sinco.animation.play((sinco.animation.name == 'blank') ? 'visible' : 'blank');
			port.animation.play((port.animation.name == 'blank') ? 'visible' : 'blank');

			FlxTween.tween(gridbg, {
				x: gridbg.x + ((port.animation.name == 'blank') ? 16 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER : -16 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER)
			}, 1/10, {});
		}

		for (text in menuboxtexts.members)
		{
			text.color = (CUR_SELECTION == text.ID) ? FlxColor.LIME : FlxColor.WHITE;
		}

		super.update(elapsed);
	}

	public function set_menuboxtexts(mapstring:String)
	{
		menuboxtexts.members = [];
		var i = 0;
		for (text in menutexts.get(mapstring))
		{
			var newtext:FlxText = new FlxText(menuselectbox.x, menuselectbox.y - menuselectbox.height + (i * 48), 0, text, 32);

			newtext.alignment = CENTER;
			newtext.ID = i;

			menuboxtexts.add(newtext);
			i++;
		}
	}
}
