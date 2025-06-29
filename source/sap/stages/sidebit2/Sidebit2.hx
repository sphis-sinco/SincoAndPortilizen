package sap.stages.sidebit2;

class Sidebit2 extends PausableState
{
        override public function new() {
                super(false);
        }

        override function create() {
                super.create();
        }

        override function postCreate() {
                super.postCreate();
        }

        override function update(elapsed:Float) {
                super.update(elapsed);

                if (Global.keyJustReleased(ESCAPE))
		{
			togglePaused();
		}
        }
        
}