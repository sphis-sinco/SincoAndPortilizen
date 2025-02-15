package sap;

import sap.modding.source.ModListManager;

class State extends FlxState
{
        override public function new() {
                super();
        }

        override dynamic function create() {
                super.create();
        }

        override dynamic function update(elapsed:Float) {
                ModListManager.update(elapsed);
                super.update(elapsed);
        }
}