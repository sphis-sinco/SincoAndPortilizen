package sap.stages.stage2;

class Stage2 extends State
{
        public static var sinco:Stage2Sinco;

        override function create() {
                super.create();

                sinco = new Stage2Sinco();
                add(sinco);
                sinco.screenCenter();
        }

        override function update(elapsed:Float) {
                super.update(elapsed);
        }
        
}