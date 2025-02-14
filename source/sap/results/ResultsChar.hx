package sap.results;

class ResultsChar extends FlxSprite
{
        public var char:String = 'sinco';

        override public function new(char:String = 'sinco') {
                super();

                this.char = char;

                loadGraphic(FileManager.getImageFile('results/${this.char}-results'), true, 128, 128);
                animation.add('awful', [0]);
                animation.add('bad', [1]);
                animation.add('good', [2]);
                animation.add('great', [3]);
                animation.add('excellent', [4]);
                animation.add('perfect', [5]);
                animation.play('perfect');

                Global.scaleSprite(this);
        }
        
}