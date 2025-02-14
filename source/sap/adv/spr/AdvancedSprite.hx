package sap.adv.spr;

class AdvancedSprite extends FlxSprite
{
        public var params:AdvancedSpriteParams;

        override public function new(?params:AdvancedSpriteParams) {
                this.params = (params != null) ? params : {
                        X: 0,
                        Y: 0,
                        asset_path: null
                };

                var posX:Float = (this.params.X != null) ? this.params.X : 0;
                var posY:Float = (this.params.Y != null) ? this.params.Y : 0;

                super(posX, posY);

                if (this.params.asset_path == null) return;
                
                if (this.params.px_animated)
                {
                        if (this.params.px_width == null) throw "Missing required ADV_SPR_Params field: px_width";
                        if (this.params.px_height == null) throw "Missing required ADV_SPR_Params field: px_height";
                        if (this.params.px_animations == null) throw "Missing required ADV_SPR_Params field: px_animations";

                        var animated:Bool = this.params.px_animated;
                        var px_w:Int = this.params.px_width;
                        var px_h:Int = this.params.px_height;

			loadGraphic(
                                FileManager.getImageFile(this.params.asset_path), 
                                animated, 
                                (animated) ? px_w : 0, 
                                (animated) ? px_h : 0
                        );

                        for (anim in this.params.px_animations)
                        {
                                if (anim.name == null) throw "Missing required px_animations field: name";
                                if (anim.frames == null) throw "Missing required px_animations field: frames";

                                var fps:Float = (anim.fps != null) ? anim.fps : 30;
                                var loop:Bool = (anim.loop != null) ? anim.loop : true;

                                animation.add(anim.name, anim.frames, fps, loop);
                        }
                }
        }
        
}