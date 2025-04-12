package sap.stages.sidebit1;

class SB1Port extends SparrowSprite
{

        override public function new() {
                super('gameplay/sidebits/port-sidebit1');

                addAnimationByPrefix('attack', 'Portilizen attack toss', 24);
                addAnimationByPrefix('hit', 'Portilizen hit', 24);
                addAnimationByPrefix('dodge', 'Portilizen dodge', 24);
                addAnimationByPrefix('idle', 'Portilizen idle', 24);
        }
        
}