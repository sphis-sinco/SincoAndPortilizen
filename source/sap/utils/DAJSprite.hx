package sap.utils;

class DAJSprite extends FlxSprite
{
        var jsonData:DynamicAnimationJSON;

        var curAnimIndx:Int = 0;

        public final HORIZONTAL_POSITION:Float = 20;
        public final VERTICAL_POSITION:Float = (Global.getCurrentState() == 'TitleState') ? 60 : 20;

        public var assetFolder:String = '';

        override public function new(file:String, assetFolder:String) {
                super();

                this.assetFolder = assetFolder;

                setPosition(HORIZONTAL_POSITION, VERTICAL_POSITION);

                jsonData = FileManager.getJSON(FileManager.getDataFile('${file}.json'));
                trace(jsonData);

                loadAnim(0);
        }

        public function loadAnim(index:Int)
        {
                curAnimIndx = index;

                var data:AnimData = jsonData.animation_data[getAnimIndex(jsonData.animation_order[index])];

                var asset:String = data.Asset;
                var name:String = data.Name;
                var fps:Float = data.FPS;
                var animated:Bool = data.Animated;
                var anim_frames:Int = data.Animation_Frames;

                loadGraphic(FileManager.getImageFile('${assetFolder}/${asset}'), animated, 32, 64);

                if (animated)
                {
                        var i:Int = 0;
                        var anim_frmes:Array<Int> = [];

                        while (anim_frmes.length < anim_frames - 1)
                        {
                                anim_frmes.push(i);
                                i++;
                        }

                        animation.add('Animation', anim_frmes, fps, false);

                        animation.play('Animation');
                }

                trace(name);

                Global.scaleSprite(this, -2);
        }

        override function update(elapsed:Float) {
                super.update(elapsed);

                if (animation.finished && curAnimIndx != jsonData.animation_order.length - 1)
                {
                        curAnimIndx++;
                        loadAnim(curAnimIndx);
                }
        }
        

        public function getAnimIndex(name:String):Int
        {
                for (i in 0...jsonData.animation_data.length) {
                        if (jsonData.animation_data[i].Name == name)
                        {
                                return i;
                        }
                }

                return 0;
        }
        

        public function getAnimData(name:String):AnimData
        {
                for (i in 0...jsonData.animation_data.length) {
                        if (jsonData.animation_data[i].Name == name)
                        {
                                return jsonData.animation_data[i];
                        }
                }

                return jsonData.animation_data[0];
        }
}