package cutscenes;

typedef PanelCutsceneSettings =
{
	var max_panels:Null<Int>;

	var panel_folder:String;
	var panel_prefix:String;
}

class PanelCutscene extends FlxState
{
	private var panel:FlxSprite = new FlxSprite();

	public var PANEL_FOLDER:String = 'intro/';
	public var PANEL_PREFIX:String = 'intro-';

	public var MAX_PANELS:Int = 5;
	public var CUR_PANEL:Int = 1;

	override public function new(cutsceneSettings:PanelCutsceneSettings)
	{
		super();

		if (cutsceneSettings.panel_folder == null)
			cutsceneSettings.panel_folder = 'intro/';
		if (cutsceneSettings.panel_prefix == null)
			cutsceneSettings.panel_prefix = 'intro-';
		if (cutsceneSettings.max_panels == null)
			cutsceneSettings.max_panels = 5;

		PANEL_FOLDER = cutsceneSettings.panel_folder;
		PANEL_PREFIX = cutsceneSettings.panel_prefix;
		MAX_PANELS = cutsceneSettings.max_panels;
	}

	override public function create()
	{
		setPanel('${PANEL_PREFIX}panel$CUR_PANEL');
		panel.antialiasing = true;
		panel.screenCenter();
		add(panel);

		FlxG.sound.play(FileManager.getSoundFile('sounds/paper-rustle'));

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justReleased.SPACE)
		{
			CUR_PANEL++;
			if (CUR_PANEL > MAX_PANELS)
			{
				finishedCutscene();
			}
			FlxG.sound.play(FileManager.getSoundFile('sounds/paper-rustle'));
			setPanel('${PANEL_PREFIX}panel$CUR_PANEL');
			panelEvents(CUR_PANEL);
		}

		super.update(elapsed);
	}

	private function setPanel(panelpath:String = 'panel1')
	{
		panel.loadGraphic(FileManager.getImageFile('cutscenes/$PANEL_FOLDER$panelpath'));
	}

	public function finishedCutscene() {}

	public function panelEvents(panel:Int) {}
}