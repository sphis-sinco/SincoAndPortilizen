package sap.changelog;

class ChangelogMenu extends State
{
        public var paper:SparrowSprite;

        override function create() {
                super.create();

                paper = new SparrowSprite('changelog/ChangelogPaper');
                paper.addAnimationByPrefix('grab', 'grab', 24, false);
                paper.addAnimationByPrefix('open', 'open', 24, false);
                paper.addAnimationByPrefix('idle', 'idle', 24, false);
                paper.playAnimation('grab');
                Global.scaleSprite(paper, -2);
                paper.screenCenter();
                add(paper);
        }

        override function update(elapsed:Float) {
                super.update(elapsed);

                if (paper.animation.finished)
                {
                        switch (paper.animation.name)
                        {
                                case 'grab': paper.playAnimation('open');
                                case 'open': paper.playAnimation('idle');
                        }
                }
        }
        
}