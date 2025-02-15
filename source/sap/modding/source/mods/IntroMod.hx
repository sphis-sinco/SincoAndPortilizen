package sap.modding.source.mods;

class IntroMod extends ModBasic
{
        override public function new() {
                super(false);
        }       

        override function create() {
                trace('Intro mod');
                super.create();
        }

        override function update(elapsed:Float) {
                super.update(elapsed);
        }
}