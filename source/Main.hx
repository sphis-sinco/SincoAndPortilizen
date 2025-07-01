package;

import openfl.filters.ShaderFilter;
import djFlixel.ui.MPlug_Audio;
import djFlixel.ui.FlxMenu;
import djFlixel.gfx.FilterFader;
import djFlixel.gfx.RainbowStripes;
import djFlixel.ui.FlxToast;
import funkin.util.logging.CrashHandler;

class Main extends Sprite
{
	public function new():Void
	{
		// We need to make the crash handler LITERALLY FIRST so nothing EVER gets past it.
		CrashHandler.initialize();
		CrashHandler.queryStatus();

		// Initialize custom logging.
		haxe.Log.trace = funkin.util.logging.AnsiTrace.trace;

		DJF.init({
			name: "Sinco and Portilizen",
			version: Global.GIT_VER,
			init: _preStart
		});

		super();
		addChild(new FlxGame(0, 0, InitState));
	}

	// - Initialize things right after FlxGame has been created
	static function _preStart()
	{
		FlxG.autoPause = false;

		// FlxToast uses a static object with color properties that can be shared between states
		// I want to reset the properties after each state switch
		FlxG.signals.postStateSwitch.add(() ->
		{
			FlxToast.INIT(true);
		});

		// Prepare those icon sizes to be used. Here FLXMenu will use sizes 8 and 12
		DJF.ui.initIcons([8, 12]);

		// Adjust some of the Sound volumes Globally
		// Everytime a sound is played with `D.snd.playV()`, this custom volume will be applied
		DJF.snd.addSoundInfos({
			cursor_high: 0.6,
			cursor_tick: 0.33
			// .. all other sounds will be played at normal volume
		});

		// Pressing F9 from anystate, will call this function
		DJF.ctrl.hotkey_add(F9, () ->
		{
			// loop
			if (shader_type == 2)
				shader_type = 0;
			else
				shader_type++;
		});
	} // -------------------------;

	/**
		Apply a shader to FlxGame (0,1,2)
		@param n 0:No Shader, remove previous one
	**/
	public static var shader_type(default, set):Int = 0;

	static var shader_kill:Void->Void = null;

	static public function set_shader_type(n:Int):Int
	{
		if (n < 0)
			n = 0;
		else if (n > 2)
			n = 2;

		if (n == shader_type)
			return n;
		if (shader_kill != null)
		{
			shader_kill();
			shader_kill = null;
		}

		var filt:Array<openfl.filters.BitmapFilter>;
		switch (n)
		{
			case 1: // hq2x
				var HQ2X = new djFlixel.gfx.shader.Hq2x();
				filt = [new ShaderFilter(HQ2X)];
			case 2: // crt
				var CRT = new djFlixel.gfx.shader.CRTShader();
				#if debug
				CRT.enable_debug_keys();
				#end
				filt = [new ShaderFilter(CRT)];
				shader_kill = CRT.removeSignals;
			default:
				filt = [];
		}

		FlxG.game.parent.filters = filt;
		trace('DJFLX, Shader Set : ${n}');
		return shader_type = n;
	} // -------------------------;

	/** Change state with an animated effect */
	static public function goto_state(S:Class<FlxState>, ?effect:String)
	{
		switch (effect)
		{
			case "fade":
				new FilterFader(() -> goto_state(S));

			default:
				Global.switchState(Type.createInstance(S, []));
		}
	} //---------------------------------------------------;

	/**
		Same sound settings for all menus created in this app
		@param	m an FlxMenu
	**/
	static public function menu_attach_sounds(m:FlxMenu)
	{
		m.plug(new MPlug_Audio({
			pageCall: 'cursor_high',
			back: 'cursor_low',
			it_fire: 'cursor_high',
			it_focus: 'cursor_tick',
			it_invalid: 'cursor_error'
		}));

		// ^ Note that these sounds will play with `D.snd.playV()`
		//   so they will apply any custom volumes set in D.snd
	} //---------------------------------------------------;

}
