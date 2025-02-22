package sap.saves;

class SaveInformation {
        public var language:String = "english";
        
        public var results:Results = {
                grade: "F",
                rank: "awful"
        };

        public var gameplaystatus:GameplayStatus = {
                levels_complete: []
        };

        public function new() {}
}

typedef GameplayStatus = {
        public var levels_complete:Array<Int>;
}

typedef Results = {
        public var grade:String;
        public var rank:String;
}