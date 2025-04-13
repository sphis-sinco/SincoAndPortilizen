import funkin.graphics.shaders.AdjustColorShader;

function initalizeMod()
{
	/*TitleState.get_VERSION_TEXT = function():String
	{
		return 'Sinco\'s cool mod v1';
	}*/

	coolShader = new AdjustColorShader();
	coolShader.hue = 255;
}

var coolShader:AdjustColorShader;

function statePostCreate()
{
	var curState:String = Global.getCurrentState();

	if (curState == 'TitleState')
	{
		TitleState.CHARACTER_RING_CHARS_SHADER.hue = 255;
		TitleState.MINI_SINCO.shader = coolShader;
		TitleState.MINI_PORTILIZEN.shader = coolShader;
	}
	else if (curState == 'MainMenu')
	{
		MainMenu.sinco.shader = coolShader;
		MainMenu.port.shader = coolShader;
	}
	else if (curState == 'State1')
	{
		State1.sinco.shader = coolShader;

		// lisn
		State1.osin.shader = coolShader;
	}
	else if (curState == 'State2')
	{
		State2.sinco.shader = coolShader;
	}
	else if (curState == 'State4')
	{
		State4.port.shader = coolShader;
	}
	else if (curState == 'Sidebit1')
	{
		Sidebit1.SINCO.shader = coolShader;
		Sidebit1.PORTILIZEN.shader = coolShader;
	}
}
