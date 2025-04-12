package sap.stages.sidebit1;

class SB1Sinco extends SparrowSprite
{

        override public function new() {
                super('gameplay/sidebits/sinco-sidebit1');

                addAnimationByPrefix('attack', 'Sinco animation attack0', 24);
                addAnimationByPrefix('attack-end', 'Sinco animation attack end0', 24);
                addAnimationByPrefix('attack-loop', 'Sinco animation attack loop0', 24);
                addAnimationByPrefix('hit', 'Sinco animation attacked0', 24);
                addAnimationByPrefix('dodge', 'Sinco animation dodge0', 24);
                addAnimationByPrefix('idle', 'Sinco animation idle0', 24);
        }
        
}