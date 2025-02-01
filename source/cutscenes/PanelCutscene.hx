package cutscenes;

class PanelCutscene extends FlxState
{
	private var panel:FlxSprite = new FlxSprite();

	public var PANEL_FOLDER:String = 'intro/';
	public var PANEL_PREFIX:String = 'intro-';

	public var MAX_PANELS:Int = 5;
	public var CUR_PANEL:Int = 1;

	override public function create()
	{
		setPanel('${PANEL_PREFIX}panel$CUR_PANEL');
		panel.screenCenter();
		add(panel);

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