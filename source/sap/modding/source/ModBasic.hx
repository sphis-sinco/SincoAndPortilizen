package sap.modding.source;

class ModBasic extends FlxBasic
{
        /**
         * This controls if the mod runs or not
         */
        public var enabled:Bool = false;

        /**
         * This tells if `create()` has been run
         */
        public var has_run_create:Bool = false;

        /**
         * New ModBasic.
         * @param enabled Should the mod already be enabled
         */
        override public function new(?enabled:Bool = false) {
                super();

                this.enabled = enabled;
        }

        /**
         * Initalization most likely to go here
         */
        public function create():Void { has_run_create = true; }

        /**
         * Run every frame
         * @param elapsed elapsed
         */
        override public function update(elapsed:Float) { super.update(elapsed); }

        /**
         * Toggles if the mod is enabled or not
         */
        public function toggleEnabled() { this.enabled = !this.enabled; }
        
}