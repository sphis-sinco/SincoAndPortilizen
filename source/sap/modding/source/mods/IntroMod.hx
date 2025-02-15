package sap.modding.source.mods;

class IntroMod extends ModBasic
{
        public static var instance:ModBasic;

        override public function new() {
                super(false);

                instance = this;
        }       

        override function create() {
                trace('Intro mod');
                super.create();
        }

        override function update(elapsed:Float) {
                super.update(elapsed);
        }
}