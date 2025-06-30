package sap.stages.sidebit2;

class Sidebit2Character extends SparrowSprite
{

        override public function new(character:String) {
                super('gameplay/sidebits/$character-sidebit2');

                addAnimationByPrefix('idle', '$character idle0', 24, true);
                addAnimationByPrefix('hit', '$character hit', 24, false);
                addAnimationByPrefix('block', '$character block', 24, false);
                addAnimationByPrefix('punch', '$character punch', 24, false);

                playAnimation('idle');
        }
        
}