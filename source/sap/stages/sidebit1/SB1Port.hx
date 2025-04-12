package sap.stages.sidebit1;

class SB1Port extends SparrowSprite
{

        override public function new() {
                super('gameplay/sidebits/port-sidebit1');

                addAnimationByPrefix('attack', 'Portilizen attack toss', 24, false);
                addAnimationByPrefix('hit', 'Portilizen hit', 24, false);
                addAnimationByPrefix('dodge', 'Portilizen dodge', 24, false);
                addAnimationByPrefix('idle', 'Portilizen idle', 24, false);
        }
        
}