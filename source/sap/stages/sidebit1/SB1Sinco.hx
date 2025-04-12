package sap.stages.sidebit1;

class SB1Sinco extends SparrowSprite
{
	override public function new()
	{
		super('gameplay/sidebits/sinco-sidebit1');

		addAnimationByPrefix('attack', 'Sinco animation attack0', 24, false);
		addAnimationByPrefix('attack-end', 'Sinco animation attack end', 24, false);
		addAnimationByPrefix('attack-loop', 'Sinco animation attack loop', 24);
		addAnimationByPrefix('hit', 'Sinco animation attacked', 24, false);
		addAnimationByPrefix('dodge', 'Sinco animation dodge', 24, false);
		addAnimationByPrefix('idle', 'Sinco animation idle', 24, false);
	}
}
