package sap.medals;

class MedalData
{
        public static var unlocked_medals:Array<String> = [];

        public static function unlockMedal(medal:String = 'award'):Medal
        {
                if (unlocked_medals.contains(medal)) { return null; }
                
                unlocked_medals.push(medal);

                FlxG.save.data.medals = unlocked_medals;

                var medalClass:Medal = new Medal(medal);

                trace('New medal: ${medal}');
                return medalClass;
        }
}